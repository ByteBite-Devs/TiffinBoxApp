import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/constants/color.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final String label;
  final String? Function(String?)? validator; // Add validator parameter

  PasswordField({
    required this.passwordController,
    required this.label,
    this.validator, // Initialize validator
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: widget.validator, // Set validator
    );
  }
}
