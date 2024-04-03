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
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
      backgroundColor: Constants().primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}
