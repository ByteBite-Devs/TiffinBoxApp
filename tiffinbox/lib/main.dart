import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/onboarding_screen.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/screens/profile_screen.dart';
import 'package:tiffinbox/screens/signup_screen.dart';
import 'package:tiffinbox/screens/splash_screen.dart';
import 'package:tiffinbox/utils/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDCFuhMxcUAFtR7wiazf8_yV8i4Qcrhzug",
      authDomain: "tiffinbox-9114a.firebaseapp.com",
      databaseURL: "https://tiffinbox-9114a-default-rtdb.firebaseio.com",
      projectId: "tiffinbox-9114a",
      storageBucket: "tiffinbox-9114a.appspot.com",
      messagingSenderId: "72750034964",
      appId: "1:72750034964:web:89f9453d754f3a2a6b3701",
      measurementId: "G-M2NTS63YN9"
    )
  );
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
        '/OnBoarding': (BuildContext context) => const OnboardingScreen(),
        '/Profile': (BuildContext context) => const ProfileScreen(),
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
