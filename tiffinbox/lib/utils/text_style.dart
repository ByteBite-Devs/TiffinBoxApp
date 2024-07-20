import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/color.dart';

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
    color: primarycolor,
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

textDecorationInput(String? label) {
  return InputDecoration(
    labelText: label ?? "",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

final whiteButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.white,
  textStyle: buttonFontStyle,
  padding: const EdgeInsets.symmetric(vertical: 16),
);