import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileService {
  final String baseUrl = 'http://192.168.56.1:8000/api/';

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