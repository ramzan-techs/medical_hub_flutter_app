// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';

import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/screens/auth/login/login_screen.dart';
import 'package:medical_hub/screens/profile_pic_view.dart';

import 'package:medical_hub/screens/user/profile/user_profile_update.dart';
import 'package:medical_hub/widgets/custom_widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../../main.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  //handling email sent button
  void _resetPassword(BuildContext context) async {
    String email = UserApis.self.email;
    try {
      CustomWidget.showProgressBar(context);
      await APIs.auth.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      // Show success message to the user
      CustomWidget.showSnackBar(
          context, 'Password change email sent successfully!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        CustomWidget.showSnackBar(context, 'Check Internet Connection!');
      } else {
        CustomWidget.showSnackBar(context, e.toString());
      }
    } catch (e) {
      // Show error message to the user
      CustomWidget.showSnackBar(
          context, 'Failed to send password change email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants().secondaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
              width: double.infinity,
            ),
            Text(
              "Profile",
              style: TextStyle(
                  color: Constants().onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: mq.width * .4,
              width: mq.width * .4,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(mq.height * .33)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileDialog(
                              name: UserApis.self.name,
                              imageUrl: UserApis.self.imageUrl)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .33),
                  child: CachedNetworkImage(
                    height: mq.width * .4,
                    width: mq.width * .4,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.lightGreen,
                        child: const Text("")),
                    imageUrl: UserApis.self.imageUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              UserApis.self.name,
              style: TextStyle(
                  color: Constants().onPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              UserApis.self.email,
              style: TextStyle(color: Constants().onPrimary, fontSize: 16),
            ),
            const SizedBox(
              height: 60,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileScreenOption(
                    onTAp: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UserProfileUpdateScreen()));
                    },
                    text: "Update Profile",
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ProfileScreenOption(
                    onTAp: () {
                      _resetPassword(context);
                    },
                    text: "Change Password",
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ProfileScreenOption(
                    onTAp: () {},
                    text: "Settings",
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ProfileScreenOption(
                    onTAp: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await UserApis.updateActiveTime(false);
                                      await APIs.auth.signOut();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const LoginScreen()),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: const Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"))
                              ],
                              title: const Text("Logout"),
                              content: const Text(
                                "Are you sure you want to logout.",
                              ),
                            );
                          });
                    },
                    text: "Logout",
                  )
                ],
              ),
            ))
          ],
        ));
  }
}

class ProfileScreenOption extends StatelessWidget {
  final String text;
  final void Function()? onTAp;
  const ProfileScreenOption({
    super.key,
    required this.text,
    this.onTAp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTAp,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
        width: mq.width * 0.9,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Constants().primaryColor))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 22, color: Constants().secondaryTextColor),
              ),
              Icon(Icons.chevron_right,
                  size: 40, color: Constants().secondaryTextColor)
            ],
          ),
        ),
      ),
    );
  }
}
