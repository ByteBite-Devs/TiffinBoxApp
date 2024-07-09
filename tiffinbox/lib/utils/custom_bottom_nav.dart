import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/screens/business/businessprofile_screen.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/screens/profile_screen.dart';
import 'package:tiffinbox/main.dart';
import '../screens/browse_screen.dart'; // For the createSlideRoute function
 
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
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.of(context).pushReplacement(createSlideRoute(const HomeScreen()));
            }
            break;
          case 1:
            if (currentIndex != 1) {
              Navigator.of(context).pushReplacement(createSlideRoute(const BrowseScreen()));
            }
            break;
          case 2:
            if (currentIndex != 2) {
              Navigator.of(context).pushReplacement(createSlideRoute(const ProfileScreen()));
            }
            break;
        }
      },
    );
  }
}


class CustomBusinessBottomNavigationBar extends StatelessWidget { 
  final int currentIndex;
 
  const CustomBusinessBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });
 
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BusinessHome'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'BusinessProfile'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.of(context).pushReplacement(createSlideRoute(const BusinessHomeScreen()));
            }
            break;
          case 1:
            if (currentIndex != 1) {
              Navigator.of(context).pushReplacement(createSlideRoute(const BrowseScreen()));
            }
            break;
          case 2:
            if (currentIndex != 2) {
              Navigator.of(context).pushReplacement(createSlideRoute(const BusinessProfileScreen()));
            }
            break;
        }
      },
    );
  }
}