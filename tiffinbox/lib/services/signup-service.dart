import 'dart:convert';
import 'package:http/http.dart' as http;
 
class SignupService {
  final String apiUrl = 'http://192.168.84.39:8000/api/';
 
  Future<Map<String, dynamic>> signup(String phoneNumber, String fullName,
      String email, String password) async {
    final response = await http.post(
      Uri.parse('${apiUrl}signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'fullName': fullName,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }
 
  Future<Map<String, dynamic>> signupBusiness(String phoneNumber, String email,
      String businessName, String password) async {
    final response = await http.post(
      Uri.parse('${apiUrl}business_signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'email': email,
        'businessName': businessName,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }
}