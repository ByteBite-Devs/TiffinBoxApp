import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/constants/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  final String _text = "TiffinBox";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Create animations for the logo and each letter
    _animations = List<Animation<double>>.generate(
      _text.length + 1, // +1 for the logo
      (int index) {
        final start = index / (_text.length + 1);
        final end = (index + 1) / (_text.length + 1);
        return Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
        );
      },
    );

    _animationController.forward();
    startTime();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  navigationPage() async {
    // if the user is loggedIn take him to home page
    // if the app is freshly installed, take to onboarding screens
    // if the user is not logged in but comming again to the app, take him to login screen

    // final prefs = await SharedPreferences.getInstance();
    // final bool? isFirstInstall = prefs.getBool('isFirstInstall');
    // final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    Navigator.of(context).pushReplacementNamed("/OnBoarding");

    // if (isFirstInstall == null || isFirstInstall == true) {
    //   // Set isFirstInstall to false after first use
    //   await prefs.setBool('isFirstInstall', false);
    //   Navigator.of(context).pushReplacementNamed(ONBOARDING);
    // } else if (isLoggedIn == true) {
    //   Navigator.of(context).pushReplacementNamed(HOME);
    // } else {
    //   Navigator.of(context).pushReplacementNamed(LOGIN);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: _animations[0],
                    builder: (BuildContext context, Widget? child) {
                      return Opacity(
                        opacity: _animations[0].value,
                        child: Image.asset(
                          'assets/logo.png',
                          height: 50.0, // Adjust the height and width as needed
                          width: 50.0,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                      width:
                          10), // Add some spacing between the logo and the text
                  // Animated text
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(_text.length, (int index) {
                      return AnimatedBuilder(
                        animation:
                            _animations[index + 1], // Adjust index for the text
                        builder: (BuildContext context, Widget? child) {
                          return Opacity(
                            opacity: _animations[index + 1].value,
                            child: Text(
                              _text[index],
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: primarycolor,
                                fontFamily: 'Poppins',
                                letterSpacing: 1.0,
                                height: 1.5,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.pink,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 20.0), // Add padding if needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Powered by',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    'assets/university_of_windsor.png', // Add the correct path to your logo asset
                    height: 100, // Adjust the height and width as needed
                    width: 100.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
