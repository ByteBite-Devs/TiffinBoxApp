import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/screens/otp-screen.dart';
import 'package:tiffinbox/services/login-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/text_style.dart';
import 'package:tiffinbox/widgets/default_button.dart';
import 'package:tiffinbox/widgets/password_filed.dart';
import 'package:tiffinbox/widgets/social_box.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  var phone = "";
  bool _signInWithPhone = false; // Default sign-in method
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  checkUserIsLoginOrNot() async {
    bool isLogin = await _googleSignIn.isSignedIn();
    if (isLogin) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return HomeScreen();
      }), (route) => false);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return UserCredential;
    } else {
      print("Google Sign in cancelled");
      return null;
    }
  }

  createUser({User? user}) async {
    await apiService.signInWithGoogle(user).then(
      (response) {
        print("RESPONSE: $response");
        if (response['status'] == 'success') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
                (route) => false,
          );
        }
        else {
          print(response['message']);
        }
      },
      onError: (error) {
        print(error);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkUserIsLoginOrNot();
  }

  void toggleSignInMethod() {
    setState(() {
      _signInWithPhone = !_signInWithPhone; // Toggle between phone and email/password sign-in
    });
  }

  Future<void> initiatePhoneNumberVerification(String phoneNumber) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  LoginScreen.phoneNumber = phoneNumber;
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {
    },
    verificationFailed: (FirebaseAuthException e) {
      print(e.message);
    },
    codeSent: (String verificationId, int? resendToken) {
      LoginScreen.verificationId = verificationId;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phone: LoginScreen.phoneNumber,
          )
        ),
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

_googleSignOn()  async {
  UserCredential? user = await signInWithGoogle();
  if (user != null) {
    createUser(user: user.user);
  }
}

_facebookSignOn() async {}

_togglePhoneSignIn() {
  setState(() {
    _signInWithPhone = !_signInWithPhone;
  });
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
                const SizedBox(height: 30),
                GradientText(
                  'Login',
                  style: defaultHeaderFontStyle,
                  colors: const [primarycolor, orangeGradientShade],
                ),
                const SizedBox(height: 30),
                // Conditional rendering based on sign-in method
                if (_signInWithPhone) ...[
                  // Phone number input and Get OTP button
                  IntlPhoneField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: "",
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                      ),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    initialCountryCode: 'CA',
                    onChanged: (value) => {
                      phone = value.completeNumber,
                      LoginScreen.phoneNumber = phone
                    }
                  ),
                  const SizedBox(height: 15),
                  DefaultButton(
                    title: 'Get OTP',
                    onpress: () async {
                      await initiatePhoneNumberVerification(phone);
                    },
                  ),
                ] else ...[
                  // Email input
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Password input
                  PasswordField(label: "Password", passwordController: _passwordController),
                  const SizedBox(height: 15),
                  // Sign in button
                  DefaultButton(
                    title: 'Sign in',
                    onpress: () async {
                      if (_signInWithPhone) {

                      } else {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        try {
                          var response =
                              await apiService.loginUser(email, password);
                          if (response['status'] == 'success') {
                            var token = response['customToken'];
                            User? user =
                                await apiService.signInWithCustomToken(token);
                            print("response: $response");
                            if (user != null) {
                              if(response['user']['role'] == 'client') {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                      (route) => false,
                                );
                              }
                              else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BusinessHomeScreen(),
                                  ),
                                      (route) => false,
                                );
                              }
                            } else {
                              print("Failed to sign in with custom token");
                          } 
                          }else {
                            print('Failed to login user: $response');
                          }
                        } catch (e) {
                          print('Failed to login user: $e');
                        }
                      }
                    },
                  ),
                ],

                const SizedBox(height: 15),
                // Other login options (Google, Facebook, etc.)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialBox(icon: 'assets/icons/google.svg', onpress: _googleSignOn),
                    SocialBox(icon: 'assets/icons/facebook.svg', onpress: _facebookSignOn),
                    SocialBox(
                      icon: !_signInWithPhone? 'assets/icons/phone.svg' : 'assets/icons/email.svg', 
                      onpress: _togglePhoneSignIn)
                  ],
                ),

                const SizedBox(height: 25),
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
                            Navigator.of(context).pushReplacementNamed("/Register");
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    text: "Own a Business",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: const TextStyle(
                          color: primarycolor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacementNamed("/BusinessRegister");
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
    );
  }  
}
