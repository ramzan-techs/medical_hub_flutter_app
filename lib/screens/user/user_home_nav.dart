import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:medical_hub/constants.dart';

import 'package:medical_hub/screens/user/home/user_home.dart';
import 'package:medical_hub/screens/user/user_profile.dart';

import 'user_chats.dart';

class UserHomeNav extends StatefulWidget {
  const UserHomeNav({super.key});

  @override
  State<UserHomeNav> createState() => _UserHomeNavState();
}

class _UserHomeNavState extends State<UserHomeNav> {
  int _selectedIndex = 0;
  final List<Widget> _screensList = [
    const UserHome(),
    const UserChats(),
    const UserProfile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screensList[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Color.fromARGB(118, 48, 207, 96))
              ]),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
            child: GNav(
                selectedIndex: _selectedIndex,
                textSize: 30,
                color: Constants().secondaryTextColor,
                rippleColor:
                    Colors.white, // tab button ripple color when pressed
                hoverColor: const Color.fromARGB(
                    255, 42, 218, 68), // tab button hover color
                haptic: true, // haptic feedback
                tabBorderRadius: 30,
                tabBackgroundColor: Colors.white,
                tabActiveBorder: Border.all(color: Colors.green),

                // tabActiveBorder: Border.all(color: ),
                // tab button border
                // tab button shadow
                curve: Curves.easeOutExpo, // tab animation curves
                duration:
                    const Duration(milliseconds: 800), // tab animation duration
                gap: 8, // the tab button gap between icon and text

                activeColor: Colors.green, // selected icon and text color
                iconSize: 30, // tab button icon size
                // selected tab background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  log(_selectedIndex.toString());
                }, // navigation bar padding
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: 'Chat',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  )
                ]),
          ),
        ));
  }
}
