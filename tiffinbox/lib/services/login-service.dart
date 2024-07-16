import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://192.168.56.1:8000/api/';

  Future<Map<String, dynamic>> signInWithGoogle(User? user) async {
    var response = await http.post(
      Uri.parse('${baseUrl}login-google'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'googleId': user?.uid ?? '',
        'email': user?.email ?? '',
        'fullName': user?.displayName ?? '',
        'profileImageUrl': user?.photoURL ?? '',
        'phoneNumber': user?.phoneNumber ?? '',
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login user: ${response.body}');
    }
  }


  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login user: ${response.body}');
    }
  }

  Future<User?> signInWithCustomToken(String token) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCustomToken(token);
      return userCredential.user;
    } catch (e) {
      print('Failed to sign in with custom token: $e');
      return null;
    }
  }


Future<void> sendVerificationCodeToBackend(String verificationId) async {
  // Send the verificationId to your Django backend
  var url = '${baseUrl}send-otp';
  var response = await http.post(
    Uri.parse(url),
    body: {'verificationId': verificationId},
  );

  if (response.statusCode == 200) {
    print('Verification ID sent to backend successfully');
  } else {
    print('Failed to send verification ID to backend');
  }
}

 Future<Map<String, dynamic>> loginWithPhone(String phone, User? user) async {
   print("Phone mumber: $phone");
   print("User: $user");
   var response = await http.post(
     Uri.parse('${baseUrl}login-phone'),
     headers: <String, String>{ 
       'Content-Type': 'application/json; charset=UTF-8',
     },
     body: jsonEncode(<String, String>{
       'phoneNumber': phone,
       'id': user?.uid ?? '',
       'email': user?.email ?? '',
       'fullName': user?.displayName ?? '',
       'profileImageUrl': user?.photoURL ?? '',       
     }),
   );

   if (response.statusCode == 200) {
     return json.decode(response.body);
   } else {
     throw Exception('Failed to login user: ${response.body}');
   }
 }
}
