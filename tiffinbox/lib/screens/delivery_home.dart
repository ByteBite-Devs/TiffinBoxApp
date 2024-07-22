import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tiffinbox/screens/order_tracking_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/order.dart' as model_order;

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  Location location = Location();
  TextEditingController orderIdController = TextEditingController();
  String deliveryAddress = '';
  String phoneNumber = '';
  String amountToCollect = '';
  String paymentType = '';
  double customerLatitude = 37.7749;
  double customerLongitude = -122.4194;
  bool showDeliveryInfo = false;
  bool isDeliveryStarted = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late CollectionReference orderCollection;
  late CollectionReference orderTrackingCollection;

  @override
  void initState() {
    orderCollection = firestore.collection('orders');
    orderTrackingCollection = firestore.collection('orderTracking');
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Boy App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/delivery2.jpg',
              width: 200,
              height: 200,
            ),
            const Text(
              'Order ID',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(
                hintText: 'OrderID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: !showDeliveryInfo,
              child: ElevatedButton(
                onPressed: () async {
                  if (orderIdController.text.isNotEmpty) {
                    model_order.Order? order = await getOrderById(context, orderIdController.text);
                    if (order != null) {
                      setState(() {
                        deliveryAddress = order.address ?? '';
                        phoneNumber = order.phone ?? '';
                        paymentType = order.payment ?? '';
                        amountToCollect = calculateTotalAmount(order.items ?? []).toString();
                        customerLatitude = order.latitude ?? 0;
                        customerLongitude = order.longitude ?? 0;
                        showDeliveryInfo = true;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: showDeliveryInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Delivery Address: $deliveryAddress',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone Number: $phoneNumber',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Payment Type: $paymentType',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount to Collect: $amountToCollect',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          launchUrl(Uri.parse('https://www.google.com/maps?q=$customerLatitude,$customerLongitude'));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.location_on),
                        label: const Text('Show Location'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _startDelivery();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start Delivery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderTrackingPage(orderId: '47790', destinationLatitude: 42.3072373, destinationLongitude: -83.0649383)),
                      );
                    },
                    child: Text('Go to Second Page'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<model_order.Order?> getOrderById(BuildContext context, String orderId) async {
    try {
      QuerySnapshot querySnapshot = await orderCollection.where('id', isEqualTo: orderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        model_order.Order order = model_order.Order.fromJson(data);
        print(order.address);

        return order;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order not found'),
          ),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
      return null;
    }
  }

  void _startDelivery() {
    setState(() {
      isDeliveryStarted = true;
    });
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied'),
            ),
          );
          return;
        }
      }

      LocationData locationData = await location.getLocation();
      print('Current Location: ${locationData.latitude}, ${locationData.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  double calculateTotalAmount(List<Map<String, dynamic>> items) {
    double totalAmount = 0;
    for (var item in items) {
      double price = item['price'];
      int quantity = item['quantity'];
      totalAmount += price * quantity;
    }
    return totalAmount;
  }
}



// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../model/order.dart';
//
// class DeliveryHomePage extends StatefulWidget {
//   const DeliveryHomePage({Key? key}) : super(key: key);
//
//   @override
//   _DeliveryHomePageState createState() => _DeliveryHomePageState();
// }
//
// class _DeliveryHomePageState extends State<DeliveryHomePage> {
//   Location location = Location();
//   TextEditingController orderIdController = TextEditingController();
//   String deliveryAddress = '';
//   String phoneNumber = '';
//   String amountToCollect = '';
//   String paymentType = '';
//   double customerLatitude = 37.7749;
//   double customerLongitude = -122.4194;
//   bool showDeliveryInfo = false;
//   bool isDeliveryStarted = false;
//
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   late CollectionReference orderCollection;
//   late CollectionReference orderTrackingCollection;
//
//   @override
//   void initState() {
//     orderCollection = firestore.collection('orders');
//     orderTrackingCollection = firestore.collection('orderTracking');
//     _getLocation();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Delivery Boy App'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Image.asset(
//               'assets/images/delivery2.jpg',
//               width: 200,
//               height: 200,
//             ),
//             const Text(
//               'Order ID',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: orderIdController,
//               decoration: const InputDecoration(
//                 hintText: 'OrderID',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Visibility(
//               visible: !showDeliveryInfo,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (orderIdController.text.isNotEmpty) {
//                     Order? order = await getOrderById(context, orderIdController.text);
//                     if (order != null) {
//                       setState(() {
//                         deliveryAddress = order.address ?? '';
//                         phoneNumber = order.phone ?? '';
//                         paymentType = order.payment ?? '';
//                         amountToCollect = calculateTotalAmount(order.items ?? []).toString();
//                         customerLatitude = order.latitude ?? 0;
//                         customerLongitude = order.longitude ?? 0;
//                         showDeliveryInfo = true;
//                       });
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text('Submit'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Visibility(
//               visible: showDeliveryInfo,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Delivery Address: $deliveryAddress',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   // const SizedBox(height: 8),
//                   // Row(
//                   //   children: [
//                   //     const Icon(Icons.phone),
//                   //     const SizedBox(width: 8),
//                   //     Text(phoneNumber),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Phone Number: $phoneNumber',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Payment Type: $paymentType',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Amount to Collect: $amountToCollect',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           launchUrl(Uri.parse('https://www.google.com/maps?q=$customerLatitude,$customerLongitude'));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           foregroundColor: Colors.white,
//                         ),
//                         icon: const Icon(Icons.location_on),
//                         label: const Text('Show Location'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           _startDelivery();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: const Text('Start Delivery'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<Order?> getOrderById(BuildContext context, String orderId) async {
//     try {
//       QuerySnapshot querySnapshot = await orderCollection.where('id', isEqualTo: orderId).get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
//         Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//
//         Order order = Order.fromJson(data);
//         print(order.address);
//
//         return order;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Order not found'),
//           ),
//         );
//         return null;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//         ),
//       );
//       return null;
//     }
//   }
//
//   double calculateTotalAmount(List<Map<String, dynamic>> items) {
//     double total = 0;
//     for (var item in items) {
//       total += item['price'] * item['quantity'];
//     }
//     return total;
//   }
//
//   Future<void> _getLocation() async {
//     try {
//       bool serviceEnabled = await location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) {
//           return;
//         }
//       }
//
//       PermissionStatus permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           return;
//         }
//       }
//
//       LocationData locationData = await location.getLocation();
//       print('Current Location: ${locationData.latitude}, ${locationData.longitude}');
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//   void _subscribeToLocationChanges() {
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       print('Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}');
//       updateOrderLocation(orderIdController.text, currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
//     });
//     location.enableBackgroundMode(enable: true);
//   }
//
//   void _startDelivery() {
//     setState(() {
//       isDeliveryStarted = true;
//     });
//     if (isDeliveryStarted) {
//       _subscribeToLocationChanges();
//       addOrderTracking(orderIdController.text, customerLatitude, customerLongitude);
//     }
//   }
//
//   Future<void> addOrderTracking(String orderId, double currentLatitude, double currentLongitude) async {
//     try {
//       await orderTrackingCollection.doc(orderId).set({
//         'orderId': orderId,
//         'latitude': currentLatitude,
//         'longitude': currentLongitude,
//       });
//     } catch (e) {
//       print('Error adding order tracking information: $e');
//     }
//   }
//
//   Future<void> updateOrderLocation(String orderId, double newLatitude, double newLongitude) async {
//     try {
//       final DocumentSnapshot orderTrackingDoc = await orderTrackingCollection.doc(orderId).get();
//
//       if (orderTrackingDoc.exists) {
//         await orderTrackingCollection.doc(orderId).update({
//           'latitude': newLatitude,
//           'longitude': newLongitude,
//         });
//       } else {
//         await addOrderTracking(orderId, newLatitude, newLongitude);
//       }
//     } catch (e) {
//       print('Error updating order location: $e');
//     }
//   }
// }
//
// class Order {
//   String? id;
//   String? address;
//   String? phone;
//   String? payment;
//   List<Map<String, dynamic>>? items;
//   double? latitude;
//   double? longitude;
//
//   Order({
//     this.id,
//     this.address,
//     this.phone,
//     this.payment,
//     this.items,
//     this.latitude,
//     this.longitude,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['id'],
//       address: json['address'],
//       phone: json['phone'],
//       payment: json['payment'],
//       items: List<Map<String, dynamic>>.from(json['items']),
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//     );
//   }
// }

// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'model/product/order.dart';

// class DeliveryHomePage extends StatefulWidget {
// const DeliveryHomePage({Key? key}): super(key: key);

// @override DeliveryHomePageState createState() = > _DeliveryHomePageState();
// }

// class _DeliveryHomePageState extends State<DeliveryHomePage> {
//   Location location = Location();
//   TextEditingController orderIdController = TextEditingController();
//   String deliveryAddress = '';
//   String phoneNumber ='';
//   String amountToCollect = '';
//   String paymentType = '';
//   double customerLatitude = 37.7749;
//   double customerLongitude = -122.4194;
//   bool showDeliveryInfo = false;
//   bool isDeliveryStarted = false;

//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   late CollectionReference orderCollection;
//   late CollectionReference orderTrackingCollection;

//   @override void initState() {
//     orderCollection = firestore.collection('orders');
//     orderTrackingCollection = firestore.collection('orderTracking');
//     _getLocation();
//     super.initState();
//   }

//   @override Widget build(BuildContext context) {
//     return Scaffold(
// appBar: AppBar(
// title: const Text('Delivery Boy App'),
// ), // AppBar
// body: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Image.asset(
// 'assets/images/delivery.png',
// width: 200,
// height: 200,
// ), // Image.asset
// const Text(
// 'Order ID',
// style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,), // TextStyle
// ), // Text
// const SizedBox(height: 8), // SizedBox
// TextField(
// controller: orderIdController,
// decoration: const InputDecoration(
//   hintText: 'OrderID',
// border: OutlineInputBorder(),
// ), // InputDecoration
// ), // TextField
// const SizedBox(height: 16), // SizedBox
// Visibility(
// visible: !showDeliveryInfo,
// child: ElevatedButton(
// onPressed: () async {
// if (orderIdController.text.isNotEmpty) {
// Order? order = await getOrderById(context, orderIdController.text);
// if (order != null) {
// setState(() {
// deliveryAddress = order.address ?? '';
// phoneNumber = order.phone ?? '';
// paymentType = order.payment ?? '';
// amountToCollect = calculateTotalAmount(order.items ?? []).toString();
// customerLatitude = order.latitude ?? 0;
// customerLongitude = order.longitude ?? 0;
// showDeliveryInfo = true;
// });
// }
// }
// },
// style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
// child: Text('Submit'),
// ), // ElevatedButton
// ), // Visibility
// const SizedBox(height: 16),
// //? Display delivery adyress and phone number if available
// Visibility(
// visible: showDeliveryInfo,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Text(), // Text
// const SizedBox(height: 8),
// Row(














// ), // Row
// Text(


// ), // Text
// const SizedBox(height: 8),
// Text(


// ), // Text
// const SizedBox(height: 16),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// ElevatedButton.icon(
//     onPressed: () {
// launchUrl(Uri.parse('https://www.google.com/maps?q=$customerLatitude,$customerLongitude')), // Launch google maps
// },
// style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
// icon: Icon(Icons. location_on),
// label: Text('Show Location'),
// ),
// ElevatedButton(
//   onPressed: () {
// _startDelivery();
//   },
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.green,
// foregroundColor: Colors.white,
// ),
// child: Text('Start Delivery'),
// ), // ElevatedButton
// ],
// ), // Row
// ],
// ), // Column
// ), // Visibility
// ],
// ), // Column
// ), // Padding
// ); // Scaffold
//   }

//   Future < Order ? > getOrderById(BuildContext context, String orderId) async {
//     try {
//       QuerySnapshot querySnapshot = await orderCollection.where('id', isEqualTo
//                                                                 : orderId);

//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//         Order order = Order.fromJson(data);
//         print(order.address);

//         return order;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content: Text('Order not found'),
// ), // SnackBar
// );
//         return null;
//       }
//     } catch (e) {
// ScaffoldMessenger.of(context).showSnackBar(
//     }

//     double calculateTotalAmount(List<Map<String, dynamic>> items) {}

//     Future<void> _getLocation() async {
//       try {
//         bool serviceEnabled = await location.serviceEnabled();
//         if (!serviceEnabled) {
//           serviceEnabled = await location.requestService();
//           if (!serviceEnabled) {
//             return;
//           }
//         }

//         PermissionStatus permissionGranted = await location.hasPermission();
//         if (permissionGranted == PermissionStatus.denied) {
//           permissionGranted = await location.requestPermission();
//           if (permissionGranted != PermissionStatus.granted) {
//             return;
//           }
//         }

//         LocationData locationData = await location.getLocation();
//         print(
//             'Current Location: ${locationData.latitude}, ${locationData.longitude}');
//       } catch (e) {
//         print('Error getting location: $e');
//       }
//     }

//     void _subscribeToLocationChanges() {
//       location.onLocationChanged.listen((LocationData currentLocation) {
//         print(
//             'Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}');
//         // Update order tracking location when location changes
// updateOrderLocation(orderIdController.text, currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
//       });
//       location.enableBackgroundMode(enable : true);
//     }

//     void _startDelivery() {
//       setState(() { isDeliveryStarted = true; });
//       if (isDeliveryStarted) {
//         _subscribeToLocationChanges();
//         addOrderTracking(orderIdController.text, customerLatitude,
//                          customerLongitude);
//       }
//     }

//     Future<void> addOrderTracking(String orderId, double currentLatitude,
//                                   double currentLongitude) async {
//       try {
//         await orderTrackingCollection.doc(orderId).set({
//           'orderId' : orderId,
//           'latitude' : currentLatitude,
//           'longitude' : currentLongitude,
//         });
//       } catch (e) {
//         print('Error adding order tracking information: $e');
//         // Handle the error as needed
//       }
//     }

//     Future<void> updateOrderLocation(String orderId, double newLatitude,
//                                      double newLongitude) async {
//       try {
//         final DocumentSnapshot orderTrackingDoc =
//             await orderTrackingCollection.doc(orderId).get();

//         // Check if the document with orderId exists
//         if (orderTrackingDoc.exists) {
//           // Update the existing document
//           await orderTrackingCollection.doc(orderId).update({
//             'latitude' : newLatitude,
//             'longitude' : newLongitude,
//           });
//         } else {
//           // Create a new document if it doesn't exist
//           await addOrderTracking(orderId, newLatitude, newLongitude);
//         }
//       } catch (e) {
//         print('Error updating order location: $e');
//         // Handle the error as needed
//       }
//     }
//   }
// }
