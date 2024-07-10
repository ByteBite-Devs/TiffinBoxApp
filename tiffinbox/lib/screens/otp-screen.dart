import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/utils/text_style.dart';
import 'package:tiffinbox/widgets/default_button.dart';
import '../utils/constants/color.dart';
import 'home_screen.dart'; // Import Home screen for navigation after successful login
import 'package:firebase_auth/firebase_auth.dart';
import '../services/login-service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required String phone}) : super(key: key);
  final String phone = '';
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService apiService = ApiService();

  Future<void> _signInWithOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginScreen.verificationId,
        smsCode: _otpController.text,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await apiService.loginWithPhone(LoginScreen.phoneNumber, 
      userCredential.user).then(
        (response) => {
          if (response['status'] == 'success') {
            if(response['user']['role'] == 'client') {
              navigateToHome()
            }
            else if(response['user']['role'] == 'business') {
              navigateToBusinessHome()
            }
          } else {
            print('Login failed')
          }
        },
        onError: (error) => print('Login failed: $error'),
      );
    } catch (e) {
      print('Failed to sign in with OTP: $e');
    }
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void navigateToBusinessHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const BusinessHomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(
                    'Enter OPT',
                  style: defaultHeaderFontStyle,
                  colors: const [primarycolor, orangeGradientShade],
                ),
                // OTP input
                // 
                Pinput(
                  controller: _otpController,
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {
                    if (value.length == 6) {
                      _signInWithOTP();
                    }
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                  validator: (value) {
                    return value == null ? 'Enter OTP' : null;
                  },
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: primarycolor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Button to verify OTP
                DefaultButton(
                  title: 'Verify OTP',
                  onpress: _signInWithOTP,
                ),
                const SizedBox(height: 15),
                // Other login options (Google, Facebook, etc.)
                // Remember me checkbox
                // Sign up link
              ],
            ),
          ),
        ),
      ),
    );
  }
}
