import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiffinbox/utils/color.dart';

final defaultFontStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 15,
    color: primarycolor,
  ),
);

final defaultHeaderFontStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 32,
    color: primarycolor,
    fontWeight: FontWeight.bold
  ),
);

final buttonFontStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 16,
    color: buttontextcolor,
    fontWeight: FontWeight.w500,
  ),
);

final boldFontStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 15,
    color: primarycolor,
    fontWeight: FontWeight.w700,
  ),
);
final titleFontStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 25,
    color: primarycolor,
    fontWeight: FontWeight.w700,
  ),
);
final logoFontStyle = GoogleFonts.sacramento(
  textStyle: const TextStyle(color: primarycolor, fontSize: 65),
);

textDecorationInput(String? label) {
  return InputDecoration(
    labelText: label ?? "",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
