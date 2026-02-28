import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHasher {
  PasswordHasher._();

  static String deriveSalt(String seed) {
    final Digest digest = sha256.convert(utf8.encode('hatim::$seed::salt'));
    return digest.toString();
  }

  static String hash(String password, {required String salt}) {
    final Digest digest = sha256.convert(
      utf8.encode('hatim::$salt::$password'),
    );
    return digest.toString();
  }

  static bool verify(
    String candidate,
    String expectedHash, {
    required String salt,
  }) {
    return hash(candidate, salt: salt) == expectedHash;
  }
}
