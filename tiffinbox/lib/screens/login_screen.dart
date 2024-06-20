import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tiffinbox/services/login-service.dart';
import 'package:tiffinbox/utils/color.dart';
import '../widgets/default_button.dart';
import 'package:tiffinbox/utils/text_style.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  checkUserIsLoginOrNot() async {
    bool isLogin = await _googleSignIn.isSignedIn();
    if (isLogin) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return HomeScreen();
      }), (route) => false);
    }}

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
  
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserIsLoginOrNot();
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
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
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
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),
                const SizedBox(height: 15),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: const Text(
                //     'Sign in',
                //     style: TextStyle(fontSize: 18),
                //   ),
                // ),
                DefaultButton(
                  title: 'Sign in',
                  onpress: () async {
                    String email = emailController.text;
                    String password = passwordController.text;
                    try {
                      var response =
                          await apiService.loginUser(email, password);
                      if (response['status'] == 'success') {
                        print('User logged in: $response');
                        Navigator.pushNamed(context, '/Home');
                      } else {
                        print('Failed to login user: $response');
                      }
                    } catch (e) {
                      print('Failed to login user: $e');
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/google.svg',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () async {
                        UserCredential? user = await signInWithGoogle();
                        if (user != null) {
                          Navigator.pushNamed(context, '/Home');
                        }
                        
                        debugPrint(user.toString());
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/facebook.svg',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/apple.svg',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () {},
                    ),
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
                            // Navigate to the register screen
                            Navigator.of(context)
                                .pushReplacementNamed("/Register");
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
