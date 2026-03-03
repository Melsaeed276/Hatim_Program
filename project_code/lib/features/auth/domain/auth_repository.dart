import 'auth_user_profile.dart';

abstract class AuthRepository {
  Future<AuthUserProfile> signUpWithPhone({
    required String name,
    required String phoneNumber,
    String? referenceCode,
    String? password,
  });

  Future<AuthUserProfile> signUpWithGoogle({
    required String name,
    String? referenceCode,
    String? password,
  });

  Future<AuthUserProfile> loginWithPhone({
    required String phoneNumber,
    String? password,
  });

  Future<AuthUserProfile> loginWithGoogle();

  Future<void> signOut();
}
