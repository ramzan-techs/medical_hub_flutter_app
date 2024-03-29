// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';

import 'package:medical_hub/screens/home_screen.dart';
import 'package:medical_hub/screens/welcome_screen.dart';

import 'auth/signup/email_verification_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      APIs.auth.authStateChanges().listen((user) {
        if (user != null) {
          // If user is signed in
          if (user.emailVerified) {
            // If user's email is verified, navigate to home screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            // If user's email is not verified, navigate to email verification screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EmailVerificationScreen()),
            );
          }
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()));
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/splash1.json'),
                Text(
                  "Medical Hub",
                  style: TextStyle(
                      color: Constants().primaryColor,
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? const Color.fromARGB(255, 12, 109, 26)
                              : Colors.green,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Constants().primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30)),
            child: const Text(
              "Powered By RamzanTechs",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
