class Validators {
  static String? phoneNumberValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    String pattern = r'^\d{10}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }
}
