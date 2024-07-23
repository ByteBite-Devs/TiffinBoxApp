import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiffinbox/screens/home_screen.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:provider/provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/text_style.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late AddressProvider _addressProvider; // Provider instance
  int? _selectedAddressIndex; // Track the selected address index

  @override
  void initState() {
    super.initState();
    _addressProvider = Provider.of<AddressProvider>(context, listen: false);
    _addressProvider.fetchAddresses(); // Fetch addresses on screen initialization
  }

  // Method to set selected address index and toggle edit/delete visibility
  void _setSelectedAddress(int index) {
    setState(() {
      if (_selectedAddressIndex == index) {
        _selectedAddressIndex = null; // Deselect if already selected
      } else {
        _selectedAddressIndex = index; // Select new address index
      }
    });
  }

  // Method to edit an address
  void _editAddress(dynamic address) {
    // Example: Navigate to an edit screen with address details
    print('Edit address: ${address['id']}');
    // Navigate to edit screen and pass the address details if required
  }

  // Method to delete an address
  void _deleteAddress(dynamic address) {
    // Example: Call provider method to delete address
    _addressProvider.setDefaultAddress(address['id']);
    setState(() {
      _selectedAddressIndex = null; // Reset selected index after deletion
    });
  }

  void _onAddressClick(dynamic address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(location: address),
      ),
    );  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Addresses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search for location',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacesAutocompleteScreen(
                      apiKey: 'AIzaSyAPkGx5Bcdq2pqVNEV-bycQD0ezI1juLbk',
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<AddressProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.addresses.length,
                  itemBuilder: (context, index) {
                    var address = provider.addresses[index];
                    return GestureDetector(
                      onTap: () {
                        _onAddressClick(address);
                      },
                      behavior: HitTestBehavior.opaque,
                      onLongPress: () => {_setSelectedAddress(index)},
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(address['name']),
                            subtitle: Text(
                                '${address['addressLine1']} ${address['addressLine2']}'),
                            trailing: address['is_default']
                                ? Icon(Icons.circle_outlined, color:primarycolor)
                                : null,
                          ),
                          AnimatedCrossFade(
                            firstChild: Container(), // Placeholder when hidden
                            secondChild: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _editAddress(address);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  style: whiteButtonStyle,
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteAddress(address);
                                  },
                                  style: whiteButtonStyle,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.setDefaultAddress(index);
                                  },
                                  style: whiteButtonStyle,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            crossFadeState: _selectedAddressIndex == index
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 300),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open bottom sheet to add new address
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddAddressBottomSheet(place: ''),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlacesAutocompleteScreen extends StatefulWidget {
  final String apiKey;

  PlacesAutocompleteScreen({required this.apiKey});

  @override
  _PlacesAutocompleteScreenState createState() =>
      _PlacesAutocompleteScreenState();
}

class _PlacesAutocompleteScreenState extends State<PlacesAutocompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: TextEditingController(),
              googleAPIKey: widget.apiKey,
              debounceTime: 600,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (prediction) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddAddressBottomSheet(place: prediction.description!),
                  ),
                );
              },
              itemClick: (prediction) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddAddressBottomSheet(place: prediction.description!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddAddressBottomSheet extends StatefulWidget {
  final String place;
  final LatLng? location;

  AddAddressBottomSheet({Key? key, required this.place, this.location}) : super(key: key);

  @override
  _AddAddressBottomSheetState createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<String, Marker> usersCarArr = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.304361491665624, -83.06623724143606),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _parsePlaceDetails(widget.place);
  }

  void _setMarker(LatLng latLng) {
    setState(() {
      usersCarArr = {
        'marker_1': Marker(
          markerId: const MarkerId('marker_1'),
          position: latLng,
        ),
      };
    });
  }

  void _parsePlaceDetails(String place) {
    List<String> addressParts = place.split(', ');

    print(addressParts);

    String capitalize(String s) =>
        s.isNotEmpty ? s[0].toUpperCase() + s.substring(1).toLowerCase() : s;
    if (addressParts.length > 3) {
      String a = addressParts[0];
      // if a contains number, put that number part in addressLine1 and rest in addressLine 2. if not put a in addressLine2
      if (a.contains(RegExp(r'\d'))) {
        _addressLine1Controller.text = a.substring(0, a.indexOf(' '));
        _addressLine2Controller.text = a.substring(a.indexOf(' ') + 1);
      } else {
        _addressLine2Controller.text = a;
      }
      _cityController.text = capitalize(addressParts[1]);
      _stateController.text = addressParts[2].toUpperCase();
    } else if (addressParts.length > 2) {
      _cityController.text = capitalize(addressParts[0]);
      _stateController.text = addressParts[1].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  markers: Set<Marker>.of(usersCarArr.values),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (latLng) {
                    _setMarker(latLng);
                  },
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _addressLine1Controller,
                decoration: InputDecoration(labelText: 'Address Line 1'),
              ),
              TextField(
                controller: _addressLine2Controller,
                decoration: InputDecoration(labelText: 'Address Line 2'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextField(
                controller: _pincodeController,
                decoration: InputDecoration(labelText: 'Pincode'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save address using the addressprovider
                  final addressProvider =
                      Provider.of<AddressProvider>(context, listen: false);
                  addressProvider.addAddress(
                    _nameController.text,
                    _phoneController.text,
                    _addressLine1Controller.text,
                    _addressLine2Controller.text,
                    _cityController.text,
                    _stateController.text,
                    _pincodeController.text,
                  );
                  Navigator.pop(context);
                },
                child: Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
