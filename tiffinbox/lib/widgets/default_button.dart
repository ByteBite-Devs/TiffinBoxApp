import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/color.dart';
import 'package:tiffinbox/utils/text_style.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final VoidCallback onpress;
  const DefaultButton({Key? key, required this.title, required this.onpress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: TextButton(
        onPressed: onpress,
        style: TextButton.styleFrom(
            backgroundColor: primarycolor,
            textStyle: buttonFontStyle,
            padding: const EdgeInsets.symmetric(vertical: 20),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0))),
        child: Text(title),
      ),
    );
  }
}