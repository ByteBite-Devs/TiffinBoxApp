import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/validators.dart';
 
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController passwordController;
  var validator;

  PasswordField({required this.label, required this.passwordController, required this.validator});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),        
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
      obscureText: _isObscured,
      validator: widget.validator, // Set validator
    );
  }
}