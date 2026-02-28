import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/auth/domain/password_hasher.dart';

void main() {
  test('hash and verify password with deterministic salt', () {
    final String salt = PasswordHasher.deriveSalt('phone_1234567890');
    final String hash = PasswordHasher.hash('secret123', salt: salt);

    expect(PasswordHasher.verify('secret123', hash, salt: salt), isTrue);
    expect(PasswordHasher.verify('wrong', hash, salt: salt), isFalse);
  });
}
