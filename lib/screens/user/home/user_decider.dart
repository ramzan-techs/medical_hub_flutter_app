import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/doctor_apis.dart';
import 'package:medical_hub/screens/auth/login/login_screen.dart';
import 'package:medical_hub/screens/doctor/doctor_home_nav.dart';
import 'package:medical_hub/screens/user/home/widgets/loader.dart';
import 'package:medical_hub/screens/user/user_home_nav.dart';

class UserDecider extends StatelessWidget {
  const UserDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIs.getUserType(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const LoaderScreen();
          case ConnectionState.active:
          case ConnectionState.done:
            final type = snapshot.data;
            // print("data in user decider ==== $type");
            if (type == "user") {
              return const UserHomeNav();
            } else if (type == "doctor") {
              DoctorApis.getDoctorInfo();
              return const DoctorHomeNav();
            } else {
              return const LoginScreen();
            }

          default:
            return const LoginScreen();
        }
      },
    );
  }
}
