import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tiffinbox/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
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

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/OnBoarding');
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
                  const SizedBox(width: 10), // Add some spacing between the logo and the text
                  // Animated text
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(_text.length, (int index) {
                      return AnimatedBuilder(
                        animation: _animations[index + 1], // Adjust index for the text
                        builder: (BuildContext context, Widget? child) {
                          return Opacity(
                            opacity: _animations[index + 1].value,
                            child: Text(
                              _text[index],
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: MyApp.primaryColor,
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
        ],
      ),
    );
  }
}
