import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressProvider with ChangeNotifier {
  List<dynamic> _addresses = [];

  List<dynamic> get addresses => _addresses;
    final url = 'http://192.168.56.1:8000/api/address';

  Future<void> fetchAddresses() async {
    final response = await http.get(
      Uri.parse('$url/all/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> loadedAddresses = [];
      var extractedData = json.decode(response.body);
      var addressesList = extractedData['addresses'] as Map<String, dynamic>;
      print(addressesList);
      addressesList.forEach((key, value) {
        loadedAddresses.add({
          'id': key,
          'name': value['name'],
          'phone_number': value['phone_number'],
          'addressLine1': value['addressLine1'],
          'addressLine2': value['addressLine2'],
          'city': value['city'],
          'state': value['state'],
          'is_default': value['is_default'],
        });
      });
      
      print("LoadAddress: $loadedAddresses");
      _addresses = loadedAddresses;
      notifyListeners();
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  Future<void> addAddress(String name, String phone, String addressLine1, String? addressLine2, String city, String state, String pinCode) async {
    final response = await http.post(
      Uri.parse('$url/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'name': name,
        'phone_number': phone,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
        'is_default': false,
      }),
    );

    if (response.statusCode == 200) {
      print("ADD RESPONSE: $response");
      fetchAddresses();
    } else {
      throw Exception('Failed to add address');
    }
  }

  Future<void> setDefaultAddress(int index) async {
    final u = '$url/setDefault/${_addresses[index]['id']}';
    final response = await http.patch(
      Uri.parse(u),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'is_default': true,
      }),
    );

    if (response.statusCode == 200) {
      fetchAddresses();
      notifyListeners();
    } else {
      throw Exception('Failed to update address');
    }
  }

  updateAddress(String address, String city, String state) async {    
    if(_addresses.isEmpty) {
      addAddress('', '', address, '', city, state, '');
    }
    final response = await http.patch(
      Uri.parse('$url/update/${_addresses[0]['id']}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "addressLine1": address,
        "addressLine2": "",
        "city": city,
        "state": state,
        "is_default":true
      }),
    );

    if (response.statusCode == 200) {
      fetchAddresses();
      notifyListeners();
    }
    else {
      throw Exception('Failed to update address');
    }
  }
}
