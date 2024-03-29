// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';

import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/auth/login/widgets.dart';
import 'package:medical_hub/screens/auth/signup/user_signup.dart';
import 'package:medical_hub/screens/custom_widgets.dart';

import 'package:medical_hub/screens/home_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    super.key,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Future<void> _reloadUserInfo() async {
    await APIs.user.reload();
  }

  Future<void> _sendEmail() async {
    await APIs.sendVerificationEmail();
  }

  @override
  void initState() {
    try {
      _sendEmail();
    } catch (e) {
      CustomWidget.showSnackBar(context, e.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TopDecoration(
                text: 'Verify Email', fontSize: 22, height: mq.height * 0.20),
          ),
          SizedBox(
            height: mq.height * 0.07,
          ),
          const WelcomeTextWidget(
            text: 'Verify Email!',
            textSize: 26,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: mq.width * 0.9,
            height: mq.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: mq.height * 0.15,
                    width: mq.height * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/email.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Verification Email ',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color.fromARGB(255, 35, 97, 37))),
                        const TextSpan(
                            text: 'has been sent to ',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 14, 173, 46),
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: APIs.user.email.toString(),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Color.fromARGB(255, 36, 39, 209),
                                fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text: ' Check your inbox or spam folder!',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 14, 173, 46),
                                fontWeight: FontWeight.bold)),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _reloadUserInfo();
                      if (APIs.user.emailVerified) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()));
                      } else {
                        CustomWidget.showSnackBar(
                            context, 'Verify Email First!');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      fixedSize: Size(
                        mq.width * 0.6,
                        mq.height * 0.06,
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Wrong Email?',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        width: 4,
                      ),

                      //sign Up in buttton

                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const UserSignUp()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Color.fromARGB(255, 72, 37, 199),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              decorationColor:
                                  Color.fromARGB(255, 17, 79, 130)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: BottomDecoration(height: mq.height * 0.19))
        ],
      ),
    );
  }
}
