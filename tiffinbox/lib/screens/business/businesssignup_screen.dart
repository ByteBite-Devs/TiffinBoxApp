import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tiffinbox/services/signup-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/text_style.dart';
import 'package:tiffinbox/widgets/default_button.dart';
import 'package:tiffinbox/widgets/password_filed.dart';

class RegisterBusinessScreen extends StatefulWidget {
  const RegisterBusinessScreen({Key? key}) : super(key: key);

  @override
  _BusinessRegistrationScreenState createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends State<RegisterBusinessScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _businessNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final signupService = SignupService();
  bool _rememberMe = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Register Your Business',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primarycolor,
                  ),
                ),
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
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: textDecorationInput("Email"),
                ),
                const SizedBox(height: 15),
                PasswordField(label: "Password", passwordController: passwordController),
                const SizedBox(height: 15),
                PasswordField(label: "Confirm Password", passwordController: confirmPasswordController),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _businessNameController,
                  keyboardType: TextInputType.name,
                  decoration: textDecorationInput("Business Name"),
                  validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
                ),
                const SizedBox(height: 15),
                DefaultButton(
                  title: 'Sign Up',
                  onpress: () async {
                    String phoneNumber = _phoneController.text;
                    String email = _emailController.text;
                    String businessName = _businessNameController.text;
                    String password = passwordController.text;

                    if (password != confirmPasswordController.text) {
                      return;
                    }

                    try {
                      var response = await signupService.signupBusiness(
                          phoneNumber, email, businessName, password);
                      if (response['status'] == 'success') {
                        Navigator.of(context).pushReplacementNamed('/Login');
                      } else {
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 20),
                const Text('Or sign up with'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/google.svg',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () {},
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
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: primarycolor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacementNamed('/Login');
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