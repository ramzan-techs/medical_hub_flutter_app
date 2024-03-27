import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/auth/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 68, 192, 90),
              Color.fromARGB(255, 3, 100, 21)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mq.height * 0.14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //app logo displayed in circle
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 123, 186, 21),
                        ),
                        height: 60,
                        width: 60,
                        child: Center(
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/doctor.png'),
                                    fit: BoxFit.scaleDown)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      //App Name
                      const Text(
                        'MEDICAL HUB',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 240, 241, 244)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  //text displayed under logo and name
                  DefaultTextStyle(
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText('FIND DOCTORS NEARBY AND CONSULTS!',
                              speed: const Duration(milliseconds: 150)),
                          TyperAnimatedText('BOOK APPOINTMENTS QUICKLY!',
                              speed: const Duration(milliseconds: 150)),
                          TyperAnimatedText('REAL TIME CHAT WITH DOCTOR!',
                              speed: const Duration(milliseconds: 150)),
                        ]),
                  )
                ],
              ),
            ),
            Column(
              children: [
                const Icon(
                  Icons.diversity_3_sharp,
                  color: Colors.white,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: RichText(
                    text: const TextSpan(
                        style: TextStyle(
                            color: Color.fromARGB(255, 248, 242, 242),
                            fontSize: 15),
                        children: [
                          TextSpan(
                              text: 'Medical Hub',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  ' is your comprehensive healthcare companion,'
                                  ' designed to make healthcare services more accessible and'
                                  ' convenient for everyone. Whether you\'re looking for a trusted'
                                  ' doctor, scheduling appointments, or managing your medical'
                                  ' records, Medical Hub has you covered.')
                        ]),
                    textAlign: TextAlign.justify,
                  ),
                ),

                //button to move ahead
                Container(
                  padding: EdgeInsets.only(top: 12, bottom: mq.height * 0.05),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));
                    },
                    style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.white,
                        fixedSize: Size.fromWidth(mq.width * 0.7)),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(
                          color: Color.fromARGB(255, 39, 95, 41),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
