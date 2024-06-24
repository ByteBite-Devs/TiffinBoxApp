import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://192.168.56.1:8000/api/';

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
      print(response);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login user: ${response.body}');
    }
  }

Future<void> initiatePhoneNumberVerification(String phoneNumber) async {
  print("Phone number: $phoneNumber");
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {
      // Auto-retrieve of SMS code completed (not necessary for this flow)
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle verification failure
      print(e.message);
    },
    codeSent: (String verificationId, int? resendToken) async {
      // Send verificationId to your backend
      await sendVerificationCodeToBackend(verificationId);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Handle timeout
    },
  );
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

}
