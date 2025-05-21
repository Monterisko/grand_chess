class AuthError {
  String message;
  String code;

  AuthError({required this.message, required this.code});

  @override
  String toString() {
    return "Error code: $code, Error message: $message";
  }
}
