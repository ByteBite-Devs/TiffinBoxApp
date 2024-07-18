import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiffinbox/screens/business/addedit-tiffin-screen.dart';
import 'package:tiffinbox/services/profile-service.dart';
import 'package:tiffinbox/services/tiffin-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

import '../../models/TiffinIntem.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({Key? key}) : super(key: key);

  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  String _userName = '';
  List<TiffinItem> tiffinItems = [];

  late Map<String, dynamic> tiffins;

  void _loadUserDetails() async {
    // Load user details from API
    var response = await ProfileService().getProfileDetails();
    if (response['status'] == 'success') {
      var userData = response['user'];
      setState(() {
        _userName = userData['business_name'];
      });
    }

    // Load tiffins from API
    response = await TiffinService().getAllBusinessTiffins(
        businessId: FirebaseAuth.instance.currentUser!.uid
    );

    if (response['status'] == 'success') {
      setState(() {
        tiffins = response['tiffins'];
        tiffins.forEach((key, value) {
          tiffinItems.add(TiffinItem(
            id: key,
            name: value['name'],
            description: value['description'],
            price: value['price'],
            mealTypes: value['mealTypes'] ?? [],
            contents: value['contents'] ?? [],
            dietType: value['dietType']?? '',
            images: value['images'] ?? [],
            frequency: value['frequency'] ?? [],
            business_id: value['business_id']
          ));
        });
      });
    }
  }

  void _navigateToAddEditScreen([TiffinItem? item]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTiffinScreen(tiffinItem: item),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TiffinBox'),
      ),
      body: tiffinItems.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () => _navigateToAddEditScreen(),
                child: const Text('Start Adding Tiffins'),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () => _navigateToAddEditScreen(),
                        child: const Icon(Icons.add),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: tiffinItems.length,
                    itemBuilder: (context, index) {
                      final item = tiffinItems[index];
                      return Card(
                        color: buttonnavbg,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          // load a network image if present or load an asset image
                          leading: Image.network(
                            item.images.isNotEmpty
                                ? item.images[0]
                                : 'https://via.placeholder.com/150',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\$${item.price.toStringAsFixed(2)}'),
                              Text(item.mealTypes!= null ? item.mealTypes!.join(', ') : ''),
                              Text(item.dietType),
                              Text("Availability: ${item.mealTypes?.join(", ") ?? 'Not Available'}"),
                              Text('Frequency: ${item.frequency!.join(", ")}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _navigateToAddEditScreen(item),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    bottomNavigationBar: CustomBusinessBottomNavigationBar(currentIndex: 0),
    );
  }
}
