import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/screens/business/businessprofile_screen.dart';
import 'package:tiffinbox/screens/cart_screen.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/onboarding_screen.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/screens/profile_screen.dart';
import 'package:tiffinbox/screens/signup_screen.dart';
import 'package:tiffinbox/screens/splash_screen.dart';
import 'package:tiffinbox/screens/business/businesssignup_screen.dart';
import 'package:tiffinbox/screens/browse_screen.dart';
import 'package:tiffinbox/screens/tiffindetails_screen.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:tiffinbox/utils/themes/theme.dart';
 
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
      appId: "1:72750034964:android:f06a3bdba16786676b3701",
      measurementId: "G-M2NTS63YN9"
    )
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider('6LdMrgcqAAAAAIvzXgkiPKc2O6arh-0S0PfAnLQr'),
  );
  runApp(
     ChangeNotifierProvider(
      create: (context) => AddressProvider(),
      child: MyApp(),
    ),
  );
}
 
class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiffinBOX',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
 
 
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => const HomeScreen(),
        '/Login': (BuildContext context) => const LoginScreen(),
        '/Register': (BuildContext context) => const RegistrationScreen(),
        '/OnBoarding': (BuildContext context) => const OnboardingScreen(),
        '/Profile': (BuildContext context) => const ProfileScreen(),
        '/Browse': (BuildContext context) => const BrowseScreen(),
        '/BusinessRegister': (BuildContext context) => const RegisterBusinessScreen(),
        '/BusinessHome': (BuildContext context) => const BusinessHomeScreen(),
        '/BusinessProfile': (BuildContext context) => const BusinessProfileScreen(),
        '/TiffinDetail': (BuildContext context) => const TiffinDetailScreen(),
        '/Cart': (BuildContext context) => const CartScreen(),
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
 
// Function to create a page route with a horizontal slide transition
Route createSlideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right to left
      const end = Offset.zero;
      const curve = Curves.ease;
 
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
 
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}