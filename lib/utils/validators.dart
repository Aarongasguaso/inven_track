class Validators {
  static bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+\$');
    return emailRegex.hasMatch(email);
  }

  static bool isFieldNotEmpty(String value) => value.trim().isNotEmpty;
}
