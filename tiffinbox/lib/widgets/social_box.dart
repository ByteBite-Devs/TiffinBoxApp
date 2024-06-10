import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/color.dart';
import 'package:tiffinbox/utils/text_style.dart';


class SocialBox extends StatelessWidget {
  final Widget icon;
  final VoidCallback onpress;
  const SocialBox({Key? key, required this.icon, required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextButton(
        onPressed: onpress,
        style: TextButton.styleFrom(
            backgroundColor: primarycolor,
            textStyle: buttonFontStyle,
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0))),
        child: icon,
      ),
    );
  }
}