// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () async {
              await APIs.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout)),
      ),
    );
  }
}
