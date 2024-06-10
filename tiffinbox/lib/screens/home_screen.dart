import 'package:flutter/material.dart';
import 'package:tiffinbox/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TiffinBox'),
      ),
      body: const Center(
        child: Text('Home Screen',
        style: TextStyle(
          color: MyApp.primaryColor
        ) ,
        ),
      ),  
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
