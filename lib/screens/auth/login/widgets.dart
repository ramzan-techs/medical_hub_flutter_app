import 'package:flutter/material.dart';

import '../../../main.dart';

class TopDecoration extends StatelessWidget {
  final double height;
  final double fontSize;
  final String text;
  const TopDecoration({
    super.key,
    required this.text,
    required this.fontSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: Material(
          child: Container(
            height: height,
            width: mq.width * 0.9,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: const Offset(0, 3), // Offset
                  ),
                ],
                color: const Color.fromARGB(255, 112, 212, 115),
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(30))),
          ),
        )),
        Stack(
          children: [
            Container(
              height: height * 0.78,
              width: mq.width * 0.76,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(255, 13, 94, 38)
                            .withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 5,
                        offset: const Offset(0, 3))
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 68, 192, 90),
                      Color.fromARGB(255, 6, 48, 14)
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30))),
            ),
            Positioned(
                bottom: 12,
                right: 24,
                child: Text(
                  text.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize,
                      color: Colors.white,
                      letterSpacing: 3.5),
                ))
          ],
        )
      ],
    );
  }
}

////bottom decoration
///
///

class BottomDecoration extends StatelessWidget {
  final double height;
  const BottomDecoration({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: -50,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  height: height,
                  width: mq.width * 0.4,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color.fromARGB(255, 82, 188, 86)),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: 0,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  height: height,
                  width: mq.width * 0.4,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color.fromARGB(255, 82, 188, 86)),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: mq.width * 0.25,
                child: Container(
                  height: height * 0.545,
                  width: mq.width * 0.5,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 28, 98, 30)
                              .withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 7,
                          offset: const Offset(0, 3))
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 68, 192, 90),
                        Color.fromARGB(255, 6, 48, 14)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    ]);
  }
}

///welcome text widget with personn icon
///
///
class WelcomeTextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  const WelcomeTextWidget({
    super.key,
    required this.text,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Text(
          text.toUpperCase(),
          style: TextStyle(
              color: Colors.green,
              fontSize: textSize,
              fontWeight: FontWeight.w700),
        ),
        Positioned(
          bottom: -40,
          right: -67,
          child: Container(
            height: 120,
            width: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/man.png'),
                    fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }
}
