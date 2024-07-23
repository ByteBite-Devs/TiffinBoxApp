import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as locations;
import 'package:tiffinbox/screens/order_tracking_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/order-service.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  locations.Location location = locations.Location();
  TextEditingController orderIdController = TextEditingController();
  dynamic order;
  dynamic deliveryAddress;
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
              keyboardType: TextInputType.number,
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
                    var response = await OrderService().getOrderAndAddress(
                      int.parse(orderIdController.text),
                    );
                    if (response['status'] == 'success') {
                      setState(() {
                        order = response['order'];
                        deliveryAddress = response['address'];
                        phoneNumber = response['phone'] ?? '';
                        paymentType = response['order']['payment'] ?? 'Cash ON Delivery';
                        amountToCollect = calculateTotalAmount(response['order']['items'] ?? []).toString();
                        showDeliveryInfo = true;
                      });
                      var locations = await locationFromAddress(
                       '${deliveryAddress['addressLine1']} ${deliveryAddress['addressLine2']} ${deliveryAddress['city']}'
                      );
                      if (locations.isNotEmpty) {
                        setState(() {
                          customerLatitude = locations[0].latitude;
                          customerLongitude = locations[0].longitude;
                        });
                      }
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
                    deliveryAddress != null ? 
                    'Delivery Address: ${deliveryAddress['addressLine1']} ${deliveryAddress['addressLine2']} ${deliveryAddress['city']}'
                    : 'No address selected',
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
                ],                
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: showDeliveryInfo,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    deliveryAddress = null;
                    phoneNumber = '';
                    paymentType = '';
                    amountToCollect = '';
                    showDeliveryInfo = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Discard'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _startDelivery() {
    setState(() {
      isDeliveryStarted = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderTrackingPage(
          orderId: order['order_number'],
          destinationLatitude: customerLatitude,
          destinationLongitude: customerLongitude,
        )),
      );
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

      locations.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == locations.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != locations.PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied'),
            ),
          );
          return;
        }
      }

      locations.LocationData locationData = await location.getLocation();
      print('Current Location: ${locationData.latitude}, ${locationData.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  double calculateTotalAmount(List<dynamic> items) {
    double totalAmount = 0;
    for (var item in items) {
      double price = item['price'];
      int quantity = item['quantity'];
      totalAmount += price * quantity;
    }
    return totalAmount;
  }
}