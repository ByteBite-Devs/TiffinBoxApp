import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/color.dart';
import 'package:tiffinbox/utils/text_style.dart';
 
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