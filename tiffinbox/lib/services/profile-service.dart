import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileService {
  final String baseUrl = 'http://192.168.137.39:8000/api/';

  Future<Map<String, dynamic>> getProfileDetails() async {
    final response = await http.get(
      Uri.parse('${baseUrl}profile?id=${FirebaseAuth.instance.currentUser!.uid}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get profile details');
    }
  }
}