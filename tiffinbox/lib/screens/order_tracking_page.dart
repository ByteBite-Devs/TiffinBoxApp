import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;
  final double destinationLatitude;
  final double destinationLongitude;

  const OrderTrackingPage({
    Key? key,
    required this.orderId,
    required this.destinationLatitude,
    required this.destinationLongitude,
  }) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng deliveryBoyLocation = const LatLng(0, 0);
  late LatLng destination;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;
  late BitmapDescriptor markerIcon;

  @override
  void initState() {
    super.initState();
    orderTrackingCollection = firestore.collection('orderTracking');
    destination = LatLng(widget.destinationLatitude, widget.destinationLongitude);
    setCustomMarkerIcon();
    startTracking(widget.orderId);
  }

  void setCustomMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/delivery.png',
    );
  }

  void startTracking(String orderId) {
    orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Position deliveryBoyPosition = Position(
          latitude: data['latitude'],
          longitude: data['longitude'],
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
        updateDeliveryBoyLocation(deliveryBoyPosition);
      }
    });
  }

  void updateDeliveryBoyLocation(Position deliveryBoyPosition) {
    setState(() {
      deliveryBoyLocation = LatLng(deliveryBoyPosition.latitude, deliveryBoyPosition.longitude);
      markers.add(
        Marker(
          markerId: const MarkerId('deliveryBoy'),
          position: deliveryBoyLocation,
          infoWindow: const InfoWindow(title: 'Delivery Boy'),
          icon: markerIcon,
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(deliveryBoyLocation, 14.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
              mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(deliveryBoyLocation, 14.0),
              );
            },
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: deliveryBoyLocation,
              zoom: 14.0,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Text(
                'Remaining Distance: ${Geolocator.distanceBetween(deliveryBoyLocation.latitude, deliveryBoyLocation.longitude, destination.latitude, destination.longitude).toStringAsFixed(2)} km',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);
//
//   @override
//   OrderTrackingPageState createState() => OrderTrackingPageState();
// }
//
// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   LatLng destination = LatLng(10.3363, 76.1489);
//   LatLng deliveryBoyLocation = LatLng(10.3225, 76.1526);
//   GoogleMapController? mapController;
//   BitmapDescriptor markerIcon =
//       BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
//   double remainingDistance = 0.0;
//
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late CollectionReference orderTrackingCollection;
//
//   void addCustomMarker() {
//     ImageConfiguration configuration =
//         ImageConfiguration(size: Size(0, 0), devicePixelRatio: 5);
//
//     BitmapDescriptor.fromAssetImage(
//             configuration, 'assets/images/food_icon4.png')
//         .then((value) {
//       setState(() {
//         markerIcon = value;
//       });
//     });
//   }
//
// // Function to update the current location
//   void updateCurrentLocation(Position position) {
//     setState(() {
//       destination = LatLng(position.latitude, position.longitude);
//     });
//   }
//
//   void updateDeliveryBoyLocation(Position position) {
//     setState(() {
//       deliveryBoyLocation = LatLng(position.latitude, position.longitude);
//     });
//
// // Update the camera position to the new location
//     mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
//
// // Calculate remaining distance
//     calculateRemainingDistance();
//   }
//
// // Function to calculate remaining distance
//   void calculateRemainingDistance() {
//     double distance = Geolocator.distanceBetween(
//       deliveryBoyLocation.latitude,
//       deliveryBoyLocation.longitude,
//       destination.latitude,
//       destination.longitude,
//     );
//
// // Convert distance from meters to kilometers
//     double distanceInKm = distance / 1000;
//
//     setState(() {
//       remainingDistance = distanceInKm;
//     });
//
//     print("Remaining Distance: $distanceInKm kilometers");
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     orderTrackingCollection = firestore.collection('orderTracking');
//     addCustomMarker();
//     startTracking('47790');
// // Subscribe to location changes
//     Geolocator.getPositionStream(
//       locationSettings:
//           LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 10),
//     ).listen((Position position) {
//       updateCurrentLocation(position);
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Tracking'),
//       ), // AppBar
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.normal,
//             onMapCreated: (controller) {
//               mapController = controller;
//             },
//             initialCameraPosition: CameraPosition(
//               target: deliveryBoyLocation,
//               zoom: 15,
//             ), // CameraPosition
//             markers: {
//               Marker(
//                 markerId: const MarkerId('destination'),
//                 position: destination,
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                     BitmapDescriptor.hueBlue),
//                 infoWindow: InfoWindow(
//                   title: 'Destination',
//                   snippet:
//                       'Lat: ${destination.latitude}, Lng: ${destination.longitude}',
//                 ), // InfoWindow
//               ), // Marker
//               Marker(
//                 markerId: const MarkerId('deliveryBoy'),
//                 position: deliveryBoyLocation,
//                 icon: markerIcon,
//                 infoWindow: InfoWindow(
//                   title: 'Delivery Boy',
//                   snippet:
//                       'Lat: ${deliveryBoyLocation.latitude}, Lng: ${deliveryBoyLocation.longitude}',
//                 ), // InfoWindow
//               ), // Marker
//             },
//           ), // GoogleMap
//           Positioned(
//             top: 16.0,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.yellow,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ), // BoxDecoration
//                 child: Text(
//                   "Remaining Distance: ${remainingDistance.toStringAsFixed(2)} kilometers",
//                   style: TextStyle(fontSize: 16.0),
//                 ), // Text
//               ), // Container
//             ), // Center
//           ), // Positioned
//         ],
//       ), // Stack
//     ); // Scaffold
//   }
//
//   void startTracking(String orderId) {
//     Timer.periodic(Duration(seconds: 1), (timer) async {
//       var trackingData = await getOrderTracking(orderId);
//
//       if (trackingData != null) {
//         double latitude = trackingData['latitude'];
//         double longitude = trackingData['longitude'];
//         updateUIWithLocation(latitude, longitude);
//         print('Latest location: $latitude, $longitude');
//       } else {
//         print('No tracking data available for order ID: $orderId');
//       }
//     }); // Timer.periodic
//   }
//
//   Future<Map<String, dynamic>?> getOrderTracking(String orderId) async {
//     try {
//       var snapshot = await orderTrackingCollection.doc(orderId).get();
//
//       if (snapshot.exists) {
//         return snapshot.data() as Map<String, dynamic>;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error getting order tracking information: $e');
//       return null;
//     }
//   }
//
//   void updateUIWithLocation(double latitude, double longitude) {
//     setState(() {
//       deliveryBoyLocation = LatLng(latitude, longitude);
//     });
//
// // Update the camera position to the new location
//     mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
//
// // Calculate remaining distance
//     calculateRemainingDistance();
//   }
// }
