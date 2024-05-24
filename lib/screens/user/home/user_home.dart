import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/data/category_image_paths.dart';
import 'package:medical_hub/data/doctor_types.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/doctor.dart';

import 'package:medical_hub/screens/user/doctor_card.dart';

import 'package:medical_hub/screens/user/doctors_screen.dart';
import 'package:medical_hub/screens/user/home/widgets/category_card.dart';
import 'package:page_transition/page_transition.dart';

import '../category/category_screen.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<Doctor> _doctorsList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Constants().secondaryColor,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 10,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello ${UserApis.self.name}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    const Text(
                      "Hava a good day!",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .33),
                  child: CachedNetworkImage(
                    height: mq.width * .16,
                    width: mq.width * .16,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(Icons.person),
                    imageUrl: UserApis.self.imageUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.person),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: mq.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Browse by Category",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Constants().secondaryColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const CategoryScreen(),
                              type: PageTransitionType.scale,
                              alignment: Alignment.centerRight,
                              duration: const Duration(milliseconds: 1200)));
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                          color: Constants().secondaryTextColor,
                          fontSize: 17,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                height: mq.width * 0.5,

                // Constrain the height of the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctorTypes.keys.toList().length,
                  itemBuilder: (context, index) {
                    // Build your list item here
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryScreen(
                                categoryName:
                                    doctorTypes.keys.toList()[index].toString(),
                              ),
                            )
                            // PageTransition(
                            //     child: CategoryScreen(
                            //       categoryName: doctorTypes.keys
                            //           .toList()[index]
                            //           .toString(),
                            //     ),
                            //     type: PageTransitionType.scale,
                            //     alignment: Alignment.centerRight,
                            //     duration: const Duration(milliseconds: 1200))
                            );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryCard(
                            imagePath: categoryImagePaths[doctorTypes.keys
                                    .toList()[index]
                                    .toString()] ??
                                "",
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            width: mq.width * 0.3,
                            child: Text(
                              doctorTypes.keys.toList()[index].toString(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants().secondaryTextColor),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Doctors",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Constants().secondaryColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DoctorsScreen())
                          // PageTransition(
                          //     child: const DoctorsScreen(),
                          //     type: PageTransitionType.scale,
                          //     alignment: Alignment.centerRight,
                          //     duration: const Duration(milliseconds: 800))
                          //
                          );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                          color: Constants().secondaryTextColor,
                          fontSize: 17,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),

              // doctors list

              SizedBox(
                  height: mq.height * 0.4,
                  // Constrain the height of the ListView
                  child: StreamBuilder(
                      stream: UserApis.getPopularDoctorsInfo(),
                      builder: ((context, snapshot) {
                        switch (snapshot.connectionState) {
                          // if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );

                          //if all or some data is loaded show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              // print("Stream error: ${snapshot.error}");
                              return const Center(
                                child: Text("Error loading data"),
                              );
                            }
                            // print("Data :${snapshot.data}");

                            if (snapshot.data != null) {
                              final data = snapshot.data!.docs;
                              _doctorsList = data
                                  .map((e) => Doctor.fromJson(e.data()))
                                  .toList();
                            } else {
                              _doctorsList = [];
                            }

                            if (_doctorsList.isNotEmpty) {
                              return ListView.builder(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  itemCount: _doctorsList.length,
                                  itemBuilder: (context, index) {
                                    return DoctorCard(
                                      doctor: _doctorsList[index],
                                    );
                                  });
                            } else {
                              return const Center(
                                child: Text("No Doctor Found"),
                              );
                            }
                        }
                      }))),
            ],
          ),
        )
      ],
    );
  }
}
