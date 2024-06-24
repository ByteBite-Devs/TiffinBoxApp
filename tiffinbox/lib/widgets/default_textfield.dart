import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/color.dart';
import 'package:tiffinbox/utils/text_style.dart';
 
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController passwordController;

  PasswordField({required this.label,
  required this.passwordController });

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
    return TextField(
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
    );
  }
}

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final Icon icon;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  const DefaultTextField({
      Key? key,
      required this.controller,
      required this.title,
      required this.icon, this.padding,
      this.titleStyle,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        style: defaultFontStyle,
        decoration: InputDecoration(
          prefixIcon: icon,
          filled: true,
          fillColor: primarycolor.withOpacity(0.05),
          hintText: title,
          hintStyle: defaultFontStyle,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.0),
            borderSide: const BorderSide(color:bordercolor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.0),
            borderSide: const BorderSide(color: bordercolor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.0),
            borderSide: const BorderSide(color: primarycolor, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        ),
      ),
    );
  }
}