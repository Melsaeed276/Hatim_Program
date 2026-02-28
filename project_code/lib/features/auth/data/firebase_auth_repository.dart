import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user_profile.dart';
import '../domain/password_hasher.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<AuthUserProfile> signUpWithPhone({
    required String name,
    required String phoneNumber,
    String? referenceCode,
    String? password,
  }) async {
    final String normalizedPhone = _normalizePhone(phoneNumber);
    if (name.trim().isEmpty || normalizedPhone.isEmpty) {
      throw AuthFailure(
        AuthFailureCode.invalidInput,
        'Name and phone number are required.',
      );
    }

    final AuthUserProfile? existing = await _findByPhone(normalizedPhone);
    if (existing != null) {
      throw AuthFailure(
        AuthFailureCode.userExists,
        'An account with this phone number already exists.',
      );
    }

    final String uid =
        'phone_${normalizedPhone.replaceAll(RegExp(r'[^0-9]'), '')}';
    final String? hash = _buildPasswordHash(uid: uid, password: password);

    final AuthUserProfile profile = AuthUserProfile(
      uid: uid,
      name: name.trim(),
      phoneNumber: normalizedPhone,
      referenceCode: _normalizeOptional(referenceCode),
      authProviders: const <String>['phone'],
      passwordEnabled: hash != null,
      passwordHash: hash,
    );

    final DateTime now = DateTime.now().toUtc();
    await _users.doc(uid).set(<String, dynamic>{
      ...profile.toMap(now: now),
      'createdAt': now.toIso8601String(),
    });

    return profile;
  }

  @override
  Future<AuthUserProfile> signUpWithGoogle({
    required String name,
    String? referenceCode,
    String? password,
  }) async {
    final User user = await _googleSignInAndGetUser();
    final DocumentReference<Map<String, dynamic>> docRef = _users.doc(user.uid);
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

    final String resolvedName = name.trim().isEmpty
        ? (user.displayName ?? '')
        : name.trim();
    if (resolvedName.isEmpty) {
      throw AuthFailure(
        AuthFailureCode.invalidInput,
        'Name is required for Google sign-up.',
      );
    }

    final String? hash = _buildPasswordHash(uid: user.uid, password: password);
    final DateTime now = DateTime.now().toUtc();

    if (!snapshot.exists) {
      final AuthUserProfile created = AuthUserProfile(
        uid: user.uid,
        name: resolvedName,
        phoneNumber: _normalizeOptional(user.phoneNumber),
        referenceCode: _normalizeOptional(referenceCode),
        authProviders: const <String>['google'],
        passwordEnabled: hash != null,
        passwordHash: hash,
      );

      await docRef.set(<String, dynamic>{
        ...created.toMap(now: now),
        'createdAt': now.toIso8601String(),
      });
      return created;
    }

    final AuthUserProfile existing = AuthUserProfile.fromMap(snapshot.data()!);
    final List<String> providers = _mergeProviders(
      existing.authProviders,
      const <String>['google'],
    );

    final AuthUserProfile updated = existing.copyWith(
      name: resolvedName,
      referenceCode:
          _normalizeOptional(referenceCode) ?? existing.referenceCode,
      authProviders: providers,
      passwordEnabled: hash != null ? true : existing.passwordEnabled,
      passwordHash: hash ?? existing.passwordHash,
      phoneNumber: existing.phoneNumber ?? _normalizeOptional(user.phoneNumber),
    );

    await docRef.update(updated.toMap(now: now));
    return updated;
  }

  @override
  Future<AuthUserProfile> loginWithPhone({
    required String phoneNumber,
    String? password,
  }) async {
    final String normalizedPhone = _normalizePhone(phoneNumber);
    if (normalizedPhone.isEmpty) {
      throw AuthFailure(
        AuthFailureCode.invalidInput,
        'Phone number is required.',
      );
    }

    final AuthUserProfile? profile = await _findByPhone(normalizedPhone);
    if (profile == null) {
      throw AuthFailure(
        AuthFailureCode.userNotFound,
        'No account found for this phone number.',
      );
    }

    if (!profile.hasProvider('phone')) {
      throw AuthFailure(
        AuthFailureCode.providerMismatch,
        'This account is not configured for phone login.',
      );
    }

    if (profile.passwordEnabled) {
      final String candidate = password?.trim() ?? '';
      if (candidate.isEmpty) {
        throw AuthFailure(
          AuthFailureCode.wrongPassword,
          'Password is required for this account.',
        );
      }

      final String salt = PasswordHasher.deriveSalt(profile.uid);
      final String expectedHash = profile.passwordHash ?? '';
      if (!PasswordHasher.verify(candidate, expectedHash, salt: salt)) {
        throw AuthFailure(AuthFailureCode.wrongPassword, 'Invalid password.');
      }
    }

    return profile;
  }

  @override
  Future<AuthUserProfile> loginWithGoogle() async {
    final User user = await _googleSignInAndGetUser();

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _users
        .doc(user.uid)
        .get();
    if (!snapshot.exists) {
      throw AuthFailure(
        AuthFailureCode.missingProfile,
        'Google account signed in but profile is missing. Please sign up first.',
      );
    }

    final AuthUserProfile profile = AuthUserProfile.fromMap(snapshot.data()!);
    if (!profile.hasProvider('google')) {
      throw AuthFailure(
        AuthFailureCode.providerMismatch,
        'This account is not configured for Google login.',
      );
    }

    return profile;
  }

  @override
  Future<void> signOut() async {
    await Future.wait<void>(<Future<void>>[
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<AuthUserProfile?> _findByPhone(String phoneNumber) async {
    final QuerySnapshot<Map<String, dynamic>> query = await _users
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return AuthUserProfile.fromMap(query.docs.first.data());
  }

  Future<User> _googleSignInAndGetUser() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      throw AuthFailure(
        AuthFailureCode.cancelled,
        'Google sign-in was cancelled.',
      );
    }

    final GoogleSignInAuthentication authData = await account.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authData.accessToken,
      idToken: authData.idToken,
    );

    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user == null) {
      throw AuthFailure(
        AuthFailureCode.unknown,
        'Failed to acquire Google user session.',
      );
    }

    return user;
  }

  String _normalizePhone(String input) {
    return input.replaceAll(RegExp(r'\s+'), '').trim();
  }

  String? _normalizeOptional(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }

  String? _buildPasswordHash({required String uid, String? password}) {
    final String clean = password?.trim() ?? '';
    if (clean.isEmpty) {
      return null;
    }

    final String salt = PasswordHasher.deriveSalt(uid);
    return PasswordHasher.hash(clean, salt: salt);
  }

  List<String> _mergeProviders(List<String> existing, List<String> adding) {
    final Set<String> providers = <String>{...existing, ...adding};
    return providers.toList(growable: false);
  }
}
