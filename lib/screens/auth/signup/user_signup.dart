// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';

import 'package:medical_hub/screens/auth/login/validation_hub.dart';
import 'package:medical_hub/screens/auth/login/widgets.dart';

import 'package:medical_hub/screens/custom_widgets.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late String _name;
  late String _email;
  late String _password;

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isSignUpBtnClicked = false;

  Future<String> _handleSignUpBtn(String email, String password) async {
    try {
      await APIs.createUser(email, password);
      return "Created";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  ValidationHub validationHub = ValidationHub();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TopDecoration(
                    text: "Sign Up", fontSize: 30, height: mq.height * 0.25),
              ),
              SizedBox(
                height: mq.height * 0.055,
              ),
              const WelcomeTextWidget(text: "Create account!", textSize: 30),
              SizedBox(
                height: mq.height * 0.03,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
                child: Form(
                  key: _formState,
                  child: Column(
                    children: [
                      //full name field

                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                        ),
                        onSaved: (value) {
                          _name = value!.trim();
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          } else if (validationHub
                              .isValidFullName(value.trim())) {
                            return null;
                          } else {
                            return 'Only alphabets allow!';
                          }
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.017,
                      ),

                      //email field

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.green,
                          ),
                        ),
                        onSaved: (newValue) {
                          _email = newValue!.trim();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          } else if (validationHub
                              .isValidEmailFormat(value.trim())) {
                            return null;
                          } else {
                            return 'Invalid Format!';
                          }
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.017,
                      ),

                      //password field

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                            hintText: 'Password',
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
                                      ))),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        onSaved: (newValue) {
                          _password = newValue!;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          } else if (validationHub.isPasswordValid(value)) {
                            return null;
                          } else {
                            return 'Must contain minimum 8 characters!';
                          }
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.017,
                      ),

                      // confirmation password field

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_showConfirmPassword,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                                icon: _showConfirmPassword
                                    ? const Icon(Icons.visibility_off,
                                        color: Colors.green)
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.green,
                                      ))),
                        onSaved: (newValue) {
                          _password = newValue!;
                        },
                        validator: (value) {
                          if (value == "") {
                            return 'Required!';
                          } else if (_password == value) {
                            return null;
                          } else {
                            return 'Not Matched!';
                          }
                        },
                      ),

                      SizedBox(
                        height: mq.height * 0.02,
                      ),

                      //sign up button

                      ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formState.currentState != null &&
                                _formState.currentState!.validate()) {
                              _formState.currentState!.save();
                              setState(() {
                                _isSignUpBtnClicked = true;
                              });
                              try {
                                String result =
                                    await _handleSignUpBtn(_email, _password);
                                if (result.toString() == 'Created') {
                                  CustomWidget.showSnackBar(
                                      context, 'Account Created Successfully!');
                                  setState(() {
                                    _isSignUpBtnClicked = false;
                                  });

                                  Navigator.pushReplacementNamed(
                                      context, '/emailVerification');
                                } else {
                                  CustomWidget.showSnackBar(
                                      context, result.toString());
                                  setState(() {
                                    _isSignUpBtnClicked = false;
                                  });
                                }
                              } catch (e) {
                                CustomWidget.showSnackBar(
                                    context, e.toString());

                                setState(() {
                                  _isSignUpBtnClicked = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              fixedSize:
                                  Size(mq.width * 0.6, mq.height * 0.06)),
                          child: _isSignUpBtnClicked
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Constants().loaderColor,
                                  ),
                                )
                              : const Text(
                                  'Sign Up',
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
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Already have a account?',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 4,
                  ),

                  //sign in buttton

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
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
        bottomNavigationBar: Container(
          color: Colors.white,
          height: mq.height * 0.15,
          child: BottomDecoration(
            height: mq.height * 0.17,
          ),
        ),
      ),
    );
  }
}
