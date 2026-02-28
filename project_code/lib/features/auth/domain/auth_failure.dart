enum AuthFailureCode {
  invalidInput,
  userExists,
  userNotFound,
  wrongPassword,
  providerMismatch,
  missingProfile,
  cancelled,
  unknown,
}

class AuthFailure implements Exception {
  AuthFailure(this.code, this.message);

  final AuthFailureCode code;
  final String message;

  @override
  String toString() => 'AuthFailure(code: $code, message: $message)';
}
