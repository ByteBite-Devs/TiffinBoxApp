import 'package:flutter/material.dart';

class SavedAddresses extends StatefulWidget  {

  @override
  State<SavedAddresses> createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Addresses"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("No saved addresses found"),
            Text("Add one now to get started!"),
          ]
        ),
      ),
    );
  }
}