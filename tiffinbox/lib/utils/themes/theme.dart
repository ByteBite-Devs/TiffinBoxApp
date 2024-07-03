import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: primarycolor,
    scaffoldBackgroundColor: bgcolor,
    textTheme: AppTextTheme.light,
    iconTheme: const IconThemeData(color: Colors.black),
    textButtonTheme: AppTextButtonTheme.buttonTheme
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: primarycolor,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTextTheme.dark,
    iconTheme: const IconThemeData(color: Colors.white),
    textButtonTheme: AppTextButtonTheme.buttonTheme

  );
}

class AppTextTheme {
  AppTextTheme._();

  static TextTheme light = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32,
      color: Colors.black,
      fontWeight: FontWeight.bold
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.bold
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 18,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16,
      color: Colors.black,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.black,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.black,
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.black,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.black,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: 10,
      color: Colors.black,
    ),
  );

  static TextTheme dark = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 18,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.white,
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.white,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.white,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: 10,
      color: Colors.white,
    ),
  );
}

class AppTextButtonTheme {
  AppTextButtonTheme._();

  static TextButtonThemeData buttonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: primarycolor,
      disabledBackgroundColor: disabledColor,
      textStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
    ),
  );
}

class AppbarTheme {
  AppbarTheme._();

  static AppBarTheme light = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.black
    ),
  );

  static AppBarTheme dark = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white
    ),
  );
}