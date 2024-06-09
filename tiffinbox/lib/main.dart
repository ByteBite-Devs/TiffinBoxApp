import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/onboarding_screen.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color primaryColor = Color(0xFFF3274C);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiffinBOX',
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        primarySwatch: _createMaterialColor(primaryColor), // Set your primary swatch
      ),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => const HomeScreen(),
        '/Login': (BuildContext context) => const LoginScreen(),
        '/OnBoarding': (BuildContext context) => const OnboardingScreen()
      },
    );
  }

  // Function to create a MaterialColor from a given Color
  MaterialColor _createMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1),
    });
  }
}
