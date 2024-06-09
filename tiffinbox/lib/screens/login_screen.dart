import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiffinbox/utils/color.dart';
import 'package:tiffinbox/widgets/default_button.dart';
import 'package:tiffinbox/widgets/default_textfield.dart';
import 'package:tiffinbox/widgets/social_box.dart';

import '../utils/text_style.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static const textFieldPadding = EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0);


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Surya', style: logoFontStyle),
            const SizedBox(
              height: 30,
            ),
            DefaultTextField(
              padding: textFieldPadding,
              controller: emailController,
              title: "Email or username",
              icon: const Icon(
                Icons.mail,
                size: 20,
                color: Colors.grey,
              ),
            ),
            DefaultTextField(
              padding: textFieldPadding,
              controller: passwordController,
              title: "Password",
              icon: const Icon(
                Icons.lock,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => {Navigator.pushNamed(context, '/forgot-password')},
                child: Text(
                  'Forgot Password?',
                  style: defaultFontStyle,
                ),
              ),
            ),
            DefaultButton(
              title: 'Sign in',
              onpress: () => {Navigator.pushNamed(context, "/")},
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                    text: "Don't have an account? ",
                    style: defaultFontStyle,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: boldFontStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => {Navigator.pushNamed(context, '/register')},
                      )
                    ]),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              alignment: Alignment.center,
              child: Text(
                'or',
                style: defaultFontStyle,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialBox(
                    onpress: () => {},
                    icon: SvgPicture.asset(
                      "assets/icons/facebook.svg",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SocialBox(
                    onpress: () => {},
                    icon: SvgPicture.asset(
                      "assets/icons/instagram.svg",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SocialBox(
                    onpress: () => {},
                    icon: SvgPicture.asset(
                      "assets/icons/apple.svg",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SocialBox(
                    onpress: () => {},
                    icon: SvgPicture.asset(
                      "assets/icons/twitter.svg",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}