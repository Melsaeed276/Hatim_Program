import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/auth/data/in_memory_auth_repository.dart';
import 'package:hatim_program/features/auth/domain/auth_failure.dart';

void main() {
  group('InMemoryAuthRepository - phone login behavior', () {
    late InMemoryAuthRepository repository;

    setUp(() {
      repository = InMemoryAuthRepository();
    });

    test('phone user without password can login without password', () async {
      await repository.signUpWithPhone(
        name: 'No Password User',
        phoneNumber: '5534567890',
      );

      final profile = await repository.loginWithPhone(
        phoneNumber: '5534567890',
      );

      expect(profile.passwordEnabled, isFalse);
      expect(profile.phoneNumber, '5534567890');
    });

    test('phone user with password must provide password', () async {
      await repository.signUpWithPhone(
        name: 'Password User',
        phoneNumber: '5534567891',
        password: 'strong-pass',
      );

      expect(
        () => repository.loginWithPhone(phoneNumber: '5534567891'),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthFailureCode.wrongPassword,
          ),
        ),
      );

      final profile = await repository.loginWithPhone(
        phoneNumber: '5534567891',
        password: 'strong-pass',
      );

      expect(profile.passwordEnabled, isTrue);
    });

    test('wrong password fails for password-enabled user', () async {
      await repository.signUpWithPhone(
        name: 'Wrong Password User',
        phoneNumber: '5534567892',
        password: 'correct-pass',
      );

      expect(
        () => repository.loginWithPhone(
          phoneNumber: '5534567892',
          password: 'bad-pass',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthFailureCode.wrongPassword,
          ),
        ),
      );
    });
  });
}
