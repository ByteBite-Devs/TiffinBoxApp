import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/common/location_manager.dart';
import 'package:tiffinbox/screens/about_us.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/screens/business/businessorderstatus_screen.dart';
import 'package:tiffinbox/screens/business/businessprofile_screen.dart';
import 'package:tiffinbox/screens/cart_screen.dart';
import 'package:tiffinbox/screens/delivery_home.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/map_screen.dart';
import 'package:tiffinbox/screens/my-orders_screen.dart';
import 'package:tiffinbox/screens/onboarding_screen.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/screens/order_status.dart';
import 'package:tiffinbox/screens/order_tracking_page.dart';
import 'package:tiffinbox/screens/payment_screen.dart';
import 'package:tiffinbox/screens/profile_screen.dart';
import 'package:tiffinbox/screens/purchase_page.dart';
import 'package:tiffinbox/screens/signup_screen.dart';
import 'package:tiffinbox/screens/splash_screen.dart';
import 'package:tiffinbox/screens/business/businesssignup_screen.dart';
import 'package:tiffinbox/screens/browse_screen.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:tiffinbox/services/cart-service.dart';
import 'package:tiffinbox/services/profile-service.dart';
import 'package:tiffinbox/utils/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          measurementId: "G-M2NTS63YN9"));

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider:
        ReCaptchaV3Provider('6LdMrgcqAAAAAIvzXgkiPKc2O6arh-0S0PfAnLQr'),
  );

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  await Stripe.instance.applySettings();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AddressProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocationManager.shared.initLocation();
    return MaterialApp(
      title: 'TiffinBOX',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      navigatorObservers: [CustomNavigatorObserver()],
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => const HomeScreen(),
        '/Login': (BuildContext context) => const LoginScreen(),
        '/Register': (BuildContext context) => const RegistrationScreen(),
        '/OnBoarding': (BuildContext context) => const OnboardingScreen(),
        '/Profile': (BuildContext context) => const ProfileScreen(),
        '/Browse': (BuildContext context) =>
            BrowseScreen(mealType: '', searchQuery: ''),
        '/BusinessRegister': (BuildContext context) =>
            const RegisterBusinessScreen(),
        '/BusinessHome': (BuildContext context) => BusinessHomeScreen(),
        '/BusinessProfile': (BuildContext context) =>
            const BusinessProfileScreen(),
        '/Cart': (BuildContext context) => const CartScreen(),
        // '/Payment': (BuildContext context) => PaymentMethodScreen(''),
        '/Payment': (BuildContext context) => PaymentMethodScreen(),
        '/OrderStatus': (BuildContext context) => const OrderStatusScreen(),
        '/Maps': (BuildContext context) => const MapScreen(),
        'BusinessOrderStatus': (BuildContext context) =>
            const BusinessOrderStatusScreen(),
        '/Purchase': (BuildContext context) => const PurchasePage(),
        // '/OrderTracking':(BuildContext context) => const OrderTrackingPage(),
        '/OrderTracking': (BuildContext context) => const OrderTrackingPage(
              orderId: 1,
              destinationLatitude: 42.3072373,
              destinationLongitude: -83.0649383,
            ),
        '/DeliveryBoyHome': (BuildContext context) => const DeliveryHomePage(),
        'MyOrders': (BuildContext context) => const MyOrdersScreen(),
        'AboutUs': (BuildContext context) => const AboutUsScreen(),
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

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute == null) {
      // If there's no previous route, navigate to HomeScreen
      Navigator.pushAndRemoveUntil(
        navigator!.context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

// Function to create a page route with a horizontal slide transition
Route createSlideRoute(Widget page, {bool isReverse = true}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin, end;
      if (isReverse) {
        begin = const Offset(1.0, 0.0); // Slide from right to left
        end = Offset.zero;
      } else {
        begin = const Offset(-1.0, 0.0); // Slide from left to right
        end = Offset.zero;
      }
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
