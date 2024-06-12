import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/onboarding_screen.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/screens/signup_screen.dart';
import 'package:tiffinbox/screens/splash_screen.dart';
import 'package:tiffinbox/utils/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiffinBOX',
      theme: ThemeData(
        primaryColor: primarycolor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        primarySwatch: _createMaterialColor(primarycolor), // Set your primary swatch
      ),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => const HomeScreen(),
        '/Login': (BuildContext context) => const LoginScreen(),
        '/Register': (BuildContext context) => const RegistrationScreen(),
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
