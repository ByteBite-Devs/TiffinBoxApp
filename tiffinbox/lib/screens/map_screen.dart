import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiffinbox/common/location_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.304361491665624, -83.06623724143606),
    zoom: 13,
  );

  late LatLng currentPosition = LatLng(42.304361491665624, -83.06623724143606);

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _moveToCurrentLocation();
            },
            markers: {
              Marker(
                markerId: MarkerId('currentLocation'),
                position: currentPosition,
                infoWindow: InfoWindow(title: 'Your Location'),
              ),
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.extended(
              onPressed: _currLocation,
              label: const Text('Your Location'),
              icon: const Icon(Icons.pin_drop),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _currLocation() async {
    final GoogleMapController controller = await _controller.future;
    await _determinePosition(); // Ensure the position is updated
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentPosition, zoom: 15),
    ));
  }

  Future<void> _moveToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentPosition, zoom: 15),
    ));
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:tiffinbox/common/location_manager.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(42.304361491665624, -83.06623724143606),
//     zoom: 13,
//   );
//
//   late LatLng currentPosition;
//   // Set<Marker> markers = Set();
//
//   Map<String, Marker> usersCarArr = {};
//
//   BitmapDescriptor? icon;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     currentPosition = LatLng(LocationManager.shared.currentPos?.latitude ?? 21.708285689346674,
//         LocationManager.shared.currentPos?.longitude ?? 72.9926376370475);
//
//     Geolocator.getPositionStream().listen((Position position) {
//       setState(() {
//         currentPosition = LatLng(position.latitude, position.longitude);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: _kGooglePlex,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//             markers: usersCarArr.values.toSet(),
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             child: FloatingActionButton.extended(
//               onPressed: _currLocation,
//               label: const Text('Your Location'),
//               icon: const Icon(Icons.pin_drop),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Future<void> _currLocation() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: currentPosition, zoom: 15)));
//   }
// }
