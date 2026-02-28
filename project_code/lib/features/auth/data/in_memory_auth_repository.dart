import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user_profile.dart';
import '../domain/password_hasher.dart';

class InMemoryAuthRepository implements AuthRepository {
  final Map<String, AuthUserProfile> _profilesByUid =
      <String, AuthUserProfile>{};

  @override
  Future<AuthUserProfile> signUpWithPhone({
    required String name,
    required String phoneNumber,
    String? referenceCode,
    String? password,
  }) async {
    final String normalizedPhone = _normalize(phoneNumber);
    if (name.trim().isEmpty || normalizedPhone.isEmpty) {
      throw AuthFailure(
        AuthFailureCode.invalidInput,
        'Name and phone number are required.',
      );
    }

    final AuthUserProfile? existing = _findByPhone(normalizedPhone);
    if (existing != null) {
      throw AuthFailure(
        AuthFailureCode.userExists,
        'Phone number already exists.',
      );
    }

    final String uid =
        'phone_${normalizedPhone.replaceAll(RegExp(r'[^0-9]'), '')}';
    final String? hash = _hash(uid, password);

    final AuthUserProfile profile = AuthUserProfile(
      uid: uid,
      name: name.trim(),
      phoneNumber: normalizedPhone,
      referenceCode: _normalizeOptional(referenceCode),
      authProviders: const <String>['phone'],
      passwordEnabled: hash != null,
      passwordHash: hash,
    );

    _profilesByUid[uid] = profile;
    return profile;
  }

  @override
  Future<AuthUserProfile> signUpWithGoogle({
    required String name,
    String? referenceCode,
    String? password,
  }) async {
    final String uid = 'google_test_uid';
    final String? hash = _hash(uid, password);

    final AuthUserProfile profile = AuthUserProfile(
      uid: uid,
      name: name.trim().isEmpty ? 'Google User' : name.trim(),
      referenceCode: _normalizeOptional(referenceCode),
      authProviders: const <String>['google'],
      passwordEnabled: hash != null,
      passwordHash: hash,
    );

    _profilesByUid[uid] = profile;
    return profile;
  }

  @override
  Future<AuthUserProfile> loginWithPhone({
    required String phoneNumber,
    String? password,
  }) async {
    final String normalized = _normalize(phoneNumber);
    final AuthUserProfile? profile = _findByPhone(normalized);

    if (profile == null) {
      throw AuthFailure(AuthFailureCode.userNotFound, 'User not found.');
    }

    if (profile.passwordEnabled) {
      final String provided = password?.trim() ?? '';
      if (provided.isEmpty) {
        throw AuthFailure(AuthFailureCode.wrongPassword, 'Password required.');
      }

      final String salt = PasswordHasher.deriveSalt(profile.uid);
      final String expected = profile.passwordHash ?? '';
      if (!PasswordHasher.verify(provided, expected, salt: salt)) {
        throw AuthFailure(AuthFailureCode.wrongPassword, 'Wrong password.');
      }
    }

    return profile;
  }

  @override
  Future<AuthUserProfile> loginWithGoogle() async {
    final AuthUserProfile? profile = _profilesByUid['google_test_uid'];
    if (profile == null) {
      throw AuthFailure(
        AuthFailureCode.missingProfile,
        'Missing Google profile.',
      );
    }
    return profile;
  }

  @override
  Future<void> signOut() async {}

  AuthUserProfile? _findByPhone(String phone) {
    for (final AuthUserProfile profile in _profilesByUid.values) {
      if (profile.phoneNumber == phone) {
        return profile;
      }
    }
    return null;
  }

  String _normalize(String input) =>
      input.replaceAll(RegExp(r'\s+'), '').trim();

  String? _normalizeOptional(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }

  String? _hash(String uid, String? password) {
    final String clean = password?.trim() ?? '';
    if (clean.isEmpty) {
      return null;
    }
    final String salt = PasswordHasher.deriveSalt(uid);
    return PasswordHasher.hash(clean, salt: salt);
  }
}
