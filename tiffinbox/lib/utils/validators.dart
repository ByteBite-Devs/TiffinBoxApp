class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
  final passwordRegex =RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (!passwordRegex.hasMatch(value)) {
      return 'Your password must include:\n-At least 8 characters long, no more than 12 characters\n-At least 1 capital letter\n-At least 1 small letter\n-At least 1 number\n-At least 1 special character';
    }
  
    return null;

  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // phone number has country code and phone number to be validated
    final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
