import 'package:flutter/material.dart';

import 'package:medical_hub/constants.dart';

class CustomWidget {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontSize: 16),
      ),
      elevation: 1,
      backgroundColor: Constants().primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: const StadiumBorder(),
    ));
  }
}
