import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_hub/screens/auth/login/forget_password_screen.dart';
import 'package:medical_hub/screens/auth/login/login_screen.dart';
import 'package:medical_hub/screens/auth/signup/email_verification_screen.dart';
import 'package:medical_hub/screens/auth/signup/user_signup.dart';

import 'package:medical_hub/screens/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:medical_hub/screens/welcome_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'firebase_options.dart';
import 'screens/user/user_home_nav.dart';

late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await _initializeFireBase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 68, 192, 90)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
                child: const UserHomeNav(),
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                duration: const Duration(milliseconds: 1200));
          case '/welcome':
            return PageTransition(
                child: const WelcomeScreen(),
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                duration: const Duration(milliseconds: 1200));
          case '/login':
            return PageTransition(
                child: const LoginScreen(),
                type: PageTransitionType.scale,
                alignment: Alignment.centerRight,
                duration: const Duration(milliseconds: 1200));
          case '/userSignUp':
            return PageTransition(
                child: const UserSignUp(),
                type: PageTransitionType.scale,
                // childCurrent: this,
                alignment: Alignment.topCenter,
                duration: const Duration(milliseconds: 1200));
          case '/forgetPassword':
            return PageTransition(
                child: const ForgetPasswordScreen(),
                type: PageTransitionType.scale,
                alignment: Alignment.centerLeft,
                duration: const Duration(milliseconds: 1200));
          case '/emailVerification':
            return PageTransition(
                child: const EmailVerificationScreen(),
                type: PageTransitionType.scale,
                alignment: Alignment.centerRight,
                duration: const Duration(milliseconds: 1200));
          default:
            return null;
        }
      },
    );
  }
}

_initializeFireBase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
