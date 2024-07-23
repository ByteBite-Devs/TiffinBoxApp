import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tiffinbox/common/location_manager.dart';
import 'package:tiffinbox/services/order-service.dart';

class OrderTrackingPage extends StatefulWidget {
  final int orderId;
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
  LatLng deliveryBoyLocation = LatLng(0, 0);
  LatLng destination = LatLng(0, 0);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;
  late BitmapDescriptor markerIcon;
  dynamic order, address;

  @override
  void initState() {
    super.initState();
    _fetchOrderAndAddressDetails();
    destination = LatLng(widget.destinationLatitude, widget.destinationLongitude);
    var currentLocation = LocationManager.shared.currentPos;
    if (currentLocation != null) {
      deliveryBoyLocation =
          LatLng(currentLocation.latitude, currentLocation.longitude);
    }
    _updateDeliveryPersonInformation(deliveryBoyLocation);
    startTracking(widget.orderId);
  }

  _updateDeliveryPersonInformation(deliveryBoyLocation) async {
    var res = await OrderService().updateDeliveryPersonDetails(order['order_number'], deliveryBoyLocation);
    if (res['status'] == 'success') {
      setState(() {
        order = res['order'];
      });
    }
  }


  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
  }

  void _fetchOrderAndAddressDetails() async {
    var res = await OrderService().getOrderAndAddress(widget.orderId);
    if (res['status'] == 'success') {
      setState(() {
        order = res['order'];
        address = res['address'];
      });
    }
    await _fetchDestination();
    setCustomMarkerIcon();
  }

  Future<void> _fetchDestination() async {
    if (address != null) {
      var locations = await locationFromAddress(
          '${address['addressLine1']} ${address['addressLine2']} ${address['city']} ${address['state']} Canada');
      print("Possible locations: $locations");
      if (locations.isNotEmpty) {
        setState(() {
          destination = LatLng(locations[0].latitude, locations[0].longitude);
        });
      }
    }
  }

  void setCustomMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/delivery.png',
    );
  }

  void startTracking(int orderId) async {
    var res = await OrderService().getOrderAndAddress(orderId);
    if (res['status'] == 'success') {
      var data = res['order'];
      var deliveryAddress = res['address'];
      var locations = await locationFromAddress(
          '${deliveryAddress['addressLine1']} ${deliveryAddress['addressLine2']} ${deliveryAddress['city']}');
      Position deliveryBoyPosition = Position(
        latitude: locations[0].latitude,
        longitude: locations[0].longitude,
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
  }

  void updateDeliveryBoyLocation(Position deliveryBoyPosition) {
    setState(() {
      deliveryBoyLocation =
          LatLng(deliveryBoyPosition.latitude, deliveryBoyPosition.longitude);
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
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
