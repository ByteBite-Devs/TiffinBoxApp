import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tiffinbox/utils/color.dart';
import 'package:tiffinbox/widgets/default_button.dart';
 
 
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
 
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}
 
class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  bool _rememberMe = false;
 
  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
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
            children: [
               const SizedBox(height: 30),
                const Text(
                  'Create Account',
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
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              DefaultButton(
                  title: 'Sign Up',
                  onpress: () => {Navigator.pushNamed(context, "/Home")},
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
                          // Handle login action
                          Navigator.of(context).pushReplacementNamed('/Login');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
          )
        ),
      ),
    );
  }
}