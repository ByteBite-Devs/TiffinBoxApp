import 'package:flutter/material.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:provider/provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

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
                    return ListTile(
                      title: Text(address.name),
                      subtitle: Text(address.address),
                      trailing: address.isDefault
                          ? Icon(Icons.check, color: Colors.green)
                          : IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          provider.setDefaultAddress(index);
                        },
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
  _PlacesAutocompleteScreenState createState() => _PlacesAutocompleteScreenState();
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
                    builder: (context) => AddAddressBottomSheet(place: prediction.description!),
                  ),
                );
              },
              itemClick: (prediction) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAddressBottomSheet(place: prediction.description!),
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

  AddAddressBottomSheet({Key? key, required this.place}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _parsePlaceDetails(widget.place);
  }

  void _parsePlaceDetails(String place) {
    List<String> addressParts = place.split(', ');

    print(addressParts);

    String capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1).toLowerCase() : s;
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
      _stateController.text = addressParts[2].toUpperCase()
    }
    else if(addressParts.length > 2) {
      _cityController.text = capitalize(addressParts[0]);
      _stateController.text = addressParts[1].toUpperCase();
    }
    else if(addressParts.length > 1) {
      _stateController.text = capitalize(addressParts[0]);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Contact Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var newAddress = (
                  name: _nameController.text,
                  phoneNumber: _phoneController.text,
                  addressLine1: _addressLine1Controller.text,
                  addressLine2: _addressLine2Controller.text,
                  city: _cityController.text,
                  state: _stateController.text,
                  pincode: _pincodeController.text,
                );
                Provider.of<AddressProvider>(context, listen: false)
                    .addAddress(newAddress);
                Navigator.pop(context);
              },
              child: Text('Save Address'),
            ),
          ],
        ),
      ),
    );
 }
}
