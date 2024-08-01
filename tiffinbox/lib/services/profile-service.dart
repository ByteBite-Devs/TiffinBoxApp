import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileProvider with ChangeNotifier {
  final String baseUrl = 'http://192.168.56.1:8000/api/';

  dynamic _profile;
  dynamic get profile => _profile;

  Future<void> getProfile() async {
    final response = await http.get(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser!.uid}'),
    );

    if (response.statusCode == 200) {
      _profile = jsonDecode(response.body)['user'];
    } else {
      throw Exception('Failed to get profile');
    }

    notifyListeners();
  }

  updateProfileDetails(String email, String name, String profileImage,
      String phone, String dob, String gender) async {
    final response = await http.patch(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'profileImage': profileImage,
        'phone': phone,
        'dob': dob,
        'gender': gender,
      }),
    );

    if (response.statusCode == 200) {
      _profile = jsonDecode(response.body)['user'];
    } else {
      throw Exception('Failed to update profile details');
    }

      notifyListeners();
  }
}

class ProfileService {
  final String baseUrl = 'http://192.168.56.1:8000/api/';

  Future<Map<String, dynamic>> getProfileDetails() async {
    final response = await http.get(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser?.uid}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get profile details');
    }
  }
}