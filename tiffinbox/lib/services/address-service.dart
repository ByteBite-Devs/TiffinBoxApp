import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressProvider with ChangeNotifier {
  List<dynamic> _addresses = [];

  List<dynamic> get addresses => _addresses;
    final url = 'http://192.168.56.1:8000/api/address';

  Future<void> fetchAddresses() async {
    final response = await http.get(
      Uri.parse('$url/all'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> loadedAddresses = [];
      final extractedData = json.decode(response.body) as List<dynamic>;

      for (var addressData in extractedData) {
        loadedAddresses.add((
          name: addressData['name'],
          phoneNumber: addressData['phone_number'],
          address: addressData['address'],
          isDefault: addressData['is_default'],
        ));
      }
      _addresses = loadedAddresses;
      notifyListeners();
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  Future<void> addAddress(dynamic address) async {
    final response = await http.post(
      Uri.parse('$url/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': address.name,
        'phone_number': address.phoneNumber,
        'address': address.address,
        'is_default': address.isDefault,
      }),
    );

    if (response.statusCode == 201) {
      fetchAddresses();
    } else {
      throw Exception('Failed to add address');
    }
  }

  Future<void> setDefaultAddress(int index) async {
    final u = '$url/${_addresses[index].id}/';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'is_default': true,
      }),
    );

    if (response.statusCode == 200) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i].isDefault = i == index;
      }
      notifyListeners();
    } else {
      throw Exception('Failed to update address');
    }
  }
}
