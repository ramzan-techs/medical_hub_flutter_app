import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';

import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/auth/login/widgets.dart';

import 'package:medical_hub/screens/home_screen.dart';

class EmailOTPVerificationScreen extends StatelessWidget {
  const EmailOTPVerificationScreen({
    super.key,
  });

  Future<void> _reloadUserInfo() async {
    APIs.user.reload();
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
                            text: 'Verification Email Link',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color.fromARGB(255, 35, 97, 37))),
                        const TextSpan(
                            text: ' has been sent to ',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 14, 173, 46),
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: APIs.user.email.toString(),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Color.fromARGB(255, 14, 51, 22),
                                fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text:
                                '.Click on the link to verify your email, after verification click on CONTINUE button to proceed account creation!',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 14, 173, 46),
                                fontWeight: FontWeight.bold)),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      _reloadUserInfo();
                      if (APIs.user.emailVerified) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Please verify email first!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          showCloseIcon: true,
                          backgroundColor: Color.fromARGB(255, 24, 76, 26),
                        ));
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
              ],
            ),
          ),
          Expanded(child: BottomDecoration(height: mq.height * 0.19))
        ],
      ),
    );
  }
}
