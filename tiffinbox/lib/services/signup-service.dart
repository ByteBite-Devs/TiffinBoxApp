import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  final String apiUrl = 'http://192.168.56.1:8000/api/';

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
        'password': password
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }
}
