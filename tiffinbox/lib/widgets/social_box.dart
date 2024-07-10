import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/text_style.dart';


class SocialBox extends StatelessWidget {
  final String icon;
  final VoidCallback onpress;
  const SocialBox({Key? key, required this.icon, required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextButton(
        onPressed: onpress,
        style: TextButton.styleFrom(
            backgroundColor: whiteText,
            textStyle: buttonFontStyle,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0))),
        child:  SvgPicture.asset(
          icon,
                        height: 40,
                        width: 40,
                      ),
      ),
    );
  }
}