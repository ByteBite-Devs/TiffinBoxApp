import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerAlert extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;

  const LocationPickerAlert({Key? key, this.onLocationSelected})
      : super(key: key);

  @override
  LocationPickerAlertState createState() => LocationPickerAlertState();
}

class LocationPickerAlertState extends State<LocationPickerAlert> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
// Handle case where permission is denied
      print('Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
// Handle case where permission is permanently denied
      print('Location permission denied forever');
    } else {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
// Handle the error, show a message to the user, or try to request location permission again.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.satellite,
                onMapCreated: (controller) {
                  mapController = controller;
                },
                onTap: (latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                  });
                },
                markers: _selectedLocation != null 
                ? {
                  Marker(
                    markerId: MarkerId('selectedLocation'),
                    position: _selectedLocation!,
                    infoWindow: InfoWindow(
                      title: 'Selected Location',
                      snippet: 'Latitude: ${_selectedLocation!.latitude}, Longitude: ${_selectedLocation!.longitude}',
                    ),
                    ),
                } 
                : {},
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? LatLng(42.317564129910195, -83.03858977791047),
                  zoom: 18,
                  ),
                        myLocationEnabled: true, // Show the user's location button
              ), // GoogleMap
            ), // Expanded
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () async {
                  if (_selectedLocation != null) {
                    print(
                      'Selected Location - Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}');
                    Navigator.pop(context);
                    widget.onLocationSelected?.call(_selectedLocation!);
                  } else {
                    // Handle case where no location is selected
                  }
                },
                child: const Icon(Icons.check, color: Colors.white),
              )
            ), // Padding
          ],
        ), // Column
      ), // SizedBox
    );
  }
}