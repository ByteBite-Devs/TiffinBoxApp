import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiffinbox/model/order.dart' as custom;
import 'package:tiffinbox/screens/pick_location_alert.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  LatLng? selectedLocation;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');

  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String paymentType = 'Cash on Delivery';
  final double price = 7.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Enter Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Text('For live tracking order please select location from map'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LocationPickerAlert(
                      onLocationSelected: (LatLng userLocation) {
                        setState(() {
                          selectedLocation = userLocation;
                        });
                        print('Selected Location - Lat: ${userLocation.latitude}, Lng: ${userLocation.longitude}');
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: Icon(Icons.location_on),
              label: const Text('Select Location from Map'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              items: const [
                DropdownMenuItem(value: 'Cash on Delivery', child: Text('Cash on Delivery')),
                DropdownMenuItem(value: 'Online Payment', child: Text('Online Payment')),
              ],
              value: paymentType,
              onChanged: (val) {
                setState(() {
                  paymentType = val!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await createOrder(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
              child: Text('Complete Purchase'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createOrder(BuildContext context) async {
    try {
      Random random = Random();
      int orderId = random.nextInt(90000) + 10000;
      DocumentReference doc = orderCollection.doc();
      custom.Order order = custom.Order(
        id: orderId.toString(),
        address: addressController.text,
        latitude: selectedLocation?.latitude,
        longitude: selectedLocation?.longitude,
        payment: paymentType,
        items: [
          {
            "price": price,
            "quantity": 1,
            "name": "Tiffin Box",
          }
        ],
        email: emailController.text,
        phone: phoneController.text,
      );
      final orderJson = order.toJson();
      await doc.set(orderJson);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order created successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      print(e);
      rethrow;
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:math';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:tiffinbox/model/order.dart' as custom;
// import 'package:tiffinbox/screens/pick_location_alert.dart';
//
// class PurchasePage extends StatefulWidget {
//   const PurchasePage({super.key});
//   @override
//   _PurchasePageState createState() => _PurchasePageState();
// }
//
// class _PurchasePageState extends State<PurchasePage> {
//   LatLng? selectedLocation;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');
//
//   TextEditingController addressController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   String paymentType = 'Cash on Delivery';
//   final double price = 7.50;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Purchase Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             TextField(
//               controller: addressController,
//               decoration: InputDecoration(
//                 hintText: 'Enter Address',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 4,
//             ),
//             const SizedBox(height: 16),
//             const Text('For live tracking order please select location from map'),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 await showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return LocationPickerAlert(
//                       onLocationSelected: (LatLng userLocation) {
//                         setState(() {
//                           selectedLocation = userLocation;
//                         });
//                         print('Selected Location - Lat: ${userLocation.latitude}, Lng: ${userLocation.longitude}');
//                       },
//                     );
//                   },
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               icon: Icon(Icons.location_on),
//               label: const Text('Select Location from Map'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(
//                 hintText: 'Enter Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: 'Enter Email',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//             DropdownButton<String>(
//               items: const [
//                 DropdownMenuItem(value: 'Cash on Delivery', child: Text('Cash on Delivery')),
//                 DropdownMenuItem(value: 'Online Payment', child: Text('Online Payment')),
//               ],
//               value: paymentType,
//               onChanged: (val) {
//                 setState(() {
//                   paymentType = val!;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 await createOrder(context);
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.green,
//               ),
//               child: Text('Complete Purchase'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> createOrder(BuildContext context) async {
//     try {
//       Random random = Random();
//       int orderId = random.nextInt(90000) + 10000;
//       DocumentReference doc = orderCollection.doc();
//       custom.Order order = custom.Order(
//         id: orderId.toString(),
//         address: addressController.text,
//         latitude: selectedLocation?.latitude,
//         longitude: selectedLocation?.longitude,
//         payment: paymentType,
//         items: [
//           {
//             "price": price,
//             "quantity": 1,
//             "name": "Tiffin Box",
//           }
//         ],
//         email: emailController.text,
//         phone: phoneController.text,
//       );
//       final orderJson = order.toJson();
//       await doc.set(orderJson);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Order created successfully'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//       print(e);
//       rethrow;
//     }
//   }
// }
