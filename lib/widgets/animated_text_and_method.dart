import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:medical_hub/main.dart';

class MethodWidget extends StatelessWidget {
  const MethodWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: mq.height * .055,
              width: mq.width * .42,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(115, 23, 156, 63),
                    blurRadius: 14,
                  ),
                ],
                color: Colors.blue.shade50,
              ),
            ),
            Container(
              height: mq.height * .24,
              width: mq.width - 30,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(115, 23, 156, 63),
                    blurRadius: 14,
                  ),
                ],
                color: Colors.blue.shade50,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        DotWidget(),
                        SizedBox(
                          width: 12,
                        ),
                        AnimatedText(msg: "Wellcome to Medical Hub"),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    VerticalSpacer(),
                    SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        DotWidget(),
                        SizedBox(
                          width: 12,
                        ),
                        AnimatedText(msg: "Accept and decline appointments"),
                      ],
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    VerticalSpacer(),
                    SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        DotWidget(),
                        SizedBox(
                          width: 12,
                        ),
                        AnimatedText(msg: "Update your profile to be live"),
                      ],
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    VerticalSpacer(),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        DotWidget(),
                        SizedBox(
                          width: 12,
                        ),
                        AnimatedText(
                            msg: "Share with your colleagues Medical Hub"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: mq.height * .058,
          width: mq.width * .42,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.blue.shade50,
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    super.key,
    required this.msg,
  });
  final String msg;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: "cera pro",
        letterSpacing: .4,
      ),
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        repeatForever: false,
        displayFullTextOnTap: true,
        totalRepeatCount: 1,
        animatedTexts: [
          TyperAnimatedText(
            msg,
          ),
        ],
      ),
    );
  }
}

class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 6),
              height: 4,
              width: 2,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              height: 4,
              width: 2,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              height: 4,
              width: 2,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 10, 55, 123).withOpacity(.2),
      ),
      child: Container(
        height: 10,
        width: 10,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Center(
            child: Container(
          height: 4,
          width: 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
