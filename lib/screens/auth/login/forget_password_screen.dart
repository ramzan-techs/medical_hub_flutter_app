// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/auth/login/login_screen.dart';
import 'package:medical_hub/screens/auth/login/widgets.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //handling email sent button
  void _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    try {
      await APIs.auth.sendPasswordResetEmail(email: email);

      setState(() {
        _isSending = false;
      });
      // Show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
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
            text: 'Recover Password!',
            textSize: 24,
          ),
          SizedBox(
            height: mq.height * 0.05,
          ),

          Container(
            padding: const EdgeInsets.all(8.0),
            width: mq.width * 0.85,
            child: const Text(
              'Enter your registered Email to receive password reset email!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          //form for credentials

          Container(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),

                SizedBox(
                  height: mq.height * 0.035,
                ),

                //login button

                ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _isSending = true;
                      });
                      _resetPassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        fixedSize: Size(mq.width * 0.6, mq.height * 0.06)),
                    child: _isSending
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Send',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          )),

                const SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Password Recovered?',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 4,
                    ),

                    //sign in buttton

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            color: Color.fromARGB(255, 72, 37, 199),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            decorationColor: Color.fromARGB(255, 17, 79, 130)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
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
