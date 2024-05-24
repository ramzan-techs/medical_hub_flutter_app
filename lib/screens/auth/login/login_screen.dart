// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/doctor_apis.dart';
import 'package:medical_hub/main.dart';

import 'package:medical_hub/screens/auth/login/validation_hub.dart';

import 'package:medical_hub/widgets/custom_widgets.dart';
import 'package:medical_hub/screens/doctor/doctor_home_nav.dart';
import 'package:medical_hub/screens/user/user_home_nav.dart';

import 'widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLogin = false;
  bool _showPassword = false;

  //handle login button
  _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formState.currentState != null &&
        _formState.currentState!.validate()) {
      _formState.currentState!.save();

      _signInWithEmailAndPassword();
    }
  }

  //to login user
  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLogin = true;
    });
    dynamic result = await APIs.loginUser(_email, _password);

    setState(() {
      _isLogin = false;
    });

    if (result['userCredential'] != null) {
      // Successfully signed in, handle navigation or other actions
      final userCredential =
          result['userCredential'] as UserCredential; // Cast to UserCredential
      if (userCredential.user!.emailVerified) {
        final type = await APIs.getUserType();
        if (type == "user") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const UserHomeNav()));
        } else if (type == "doctor") {
          await DoctorApis.getDoctorInfo();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const DoctorHomeNav()));
        }
      } else {
        Navigator.pushReplacementNamed(context, '/emailVerification');
      }
    } else {
      // Handle sign in errors
      String errorMessage = result['error'];
      // Show error message to the user
      CustomWidget.showSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          SizedBox(
              width: double.infinity,
              child: TopDecoration(
                height: mq.height * 0.25,
                text: 'Login',
                fontSize: 36,
              )),
          SizedBox(
            height: mq.height * 0.067,
          ),
          const WelcomeTextWidget(
            text: 'Welcome Back!',
            textSize: 26,
          ),
          SizedBox(
            height: mq.height * 0.05,
          ),

          //form for credentials

          Container(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
            child: Form(
              key: _formState,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      suffixIcon: Icon(
                        Icons.email,
                        color: Colors.green,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email Required';
                      } else if (ValidationHub()
                          .isValidEmailFormat(value.trim())) {
                        return null;
                      } else {
                        return 'Invalid Email';
                      }
                    },
                  ),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: _showPassword
                                  ? const Icon(Icons.visibility_off,
                                      color: Colors.green)
                                  : const Icon(
                                      Icons.visibility,
                                      color: Colors.green,
                                    )),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          log(_password);
                          if (value!.isEmpty) {
                            return 'Password Required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      //froget password button

                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/forgetPassword');
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 72, 37, 199),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decorationColor:
                                  Color.fromARGB(255, 17, 79, 130)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: mq.height * 0.035,
                  ),

                  //login button

                  ElevatedButton(
                      onPressed: () {
                        _isLogin ? null : _handleLogin();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          fixedSize: Size(mq.width * 0.6, mq.height * 0.06)),
                      child: _isLogin
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Don\'t have a account?',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                width: 4,
              ),

              //sign up buttton

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/userSignUp');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Color.fromARGB(255, 72, 37, 199),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationColor: Color.fromARGB(255, 17, 79, 130)),
                ),
              ),
            ],
          ),

          Expanded(
              child: BottomDecoration(
            height: mq.height * 0.24,
          ))
        ]),
      ),
    );
  }
}
