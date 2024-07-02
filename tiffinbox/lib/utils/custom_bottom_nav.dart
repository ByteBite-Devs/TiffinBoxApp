import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/profile_screen.dart';
import 'package:tiffinbox/main.dart'; // For the createSlideRoute function

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.of(context).pushReplacement(createSlideRoute(const HomeScreen()));
            }
            break;
          case 2:
            if (currentIndex != 2) {
              Navigator.of(context).pushReplacement(createSlideRoute(const ProfileScreen()));
            }
            break;
        // Add cases for other navigation as needed
        }
      },
    );
  }
}
