import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/screens/delivery_home.dart';
import 'package:tiffinbox/screens/otp-screen.dart';
import 'package:tiffinbox/services/login-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/text_style.dart';
import 'package:tiffinbox/widgets/default_button.dart';
import 'package:tiffinbox/widgets/password_field.dart';
import 'package:tiffinbox/widgets/social_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String verificationId = '';
  static String phoneNumber = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation
  var phone = "";
  bool _rememberMe = false;
  bool isLoading = false;

  Future<void> loginUser(String phoneNumber) async {
    // Function to handle login
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        LoginScreen.verificationId = verificationId;
        LoginScreen.phoneNumber = phoneNumber;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
              phone: phoneNumber,
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to home screen or wherever you need
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey, // Assign key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  GradientText(
                    'Welcome Back!',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: const [Colors.orange, primarycolor],
                  ),
                  const SizedBox(height: 10),
                  const Text('Login to your account'),
                  const SizedBox(height: 30),
                  IntlPhoneField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: "",
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    initialCountryCode: 'CA',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    validator: (phone) {
                      if (phone == null || phone.completeNumber.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: textDecorationInput("Email or Phone"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email or Phone is required';
                      }
                      if (!EmailValidator.validate(value) && value.length < 10) {
                        return 'Enter a valid email or phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    label: "Password",
                    passwordController: _passwordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  DefaultButton(
                    title: 'Login',
                    onpress: () {
                      if (_formKey.currentState!.validate()) { // Validate form
                        if (_phoneController.text.isNotEmpty) {
                          loginUser(_phoneController.text);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Or sign in with'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialBox(
                        icon: "assets/icons/google.svg",
                        onpress: signInWithGoogle,
                      ),
                      const SizedBox(width: 10),
                      SocialBox(
                        icon: "assets/icons/facebook.svg",
                        onpress: () {},
                      ),
                      const SizedBox(width: 10),
                      SocialBox(
                        icon: "assets/icons/apple.svg",
                        onpress: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/Register');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
