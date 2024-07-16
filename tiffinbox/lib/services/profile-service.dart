import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile {
  String id;
  String name;
  String email;
  String profileImage;
  String phone;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phone,
  });

  static Profile? fromJson(decode) {
    if (decode != null) {
      return Profile(
        id: decode['id'],
        name: decode['name'],
        email: decode['email'],
        profileImage: decode['profileImage'],
        phone: decode['phone'],
      );
    }
    return null;
  }
}

class ProfileProvider with ChangeNotifier {
  final String baseUrl = 'http://192.168.84.39:8000/api/';

  Profile? _profile;
  Profile? get profile => _profile;

  Future<void> getProfile() async {
    final response = await http.get(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser!.uid}'),
    );

    if (response.statusCode == 200) {
      _profile = Profile.fromJson(json.decode(response.body)['user']);
    } else {
      throw Exception('Failed to get profile');
    }

    notifyListeners();
  }
  
  Future<void> updateProfileDetails(String email, String name, String profileImage, String phone) async {
    final response = await http.patch(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'profileImage': profileImage,
        'phone': phone
      }),
    );

    if (response.statusCode == 200) {
      _profile = Profile.fromJson(json.decode(response.body)['user']);
    } else {
      throw Exception('Failed to update profile details');
    }

    notifyListeners();
  }
}

class ProfileService {
  final String baseUrl = 'http://192.168.84.39:8000/api/';

  Future<Map<String, dynamic>> getProfileDetails() async {
    final response = await http.get(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser!.uid}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get profile details');
    }
  }
  Future<Map<String, dynamic>> updateProfileDetails(String email, String name, String profileImage, String phone) async {
    final response = await http.patch(
      Uri.parse('${baseUrl}profile/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'profileImage': profileImage,
        'phone': phone
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update profile details');
    }
  }
}