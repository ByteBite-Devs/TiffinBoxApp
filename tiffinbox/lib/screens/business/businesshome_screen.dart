import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({Key? key}) : super(key: key);

  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Home'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text('Business Home'),
      ),
      bottomNavigationBar: const CustomBusinessBottomNavigationBar(currentIndex: 0),
    );
  }
}