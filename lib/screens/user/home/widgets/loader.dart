// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/splash1.json'),
                Text(
                  "Medical Hub",
                  style: TextStyle(
                      color: Constants().primaryColor,
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? const Color.fromARGB(255, 12, 109, 26)
                              : Colors.green,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Constants().primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              "Powered By RamzanTechs",
              style: TextStyle(
                  color: Constants().primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
