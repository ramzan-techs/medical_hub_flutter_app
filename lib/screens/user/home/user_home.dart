import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/data/category_image_paths.dart';
import 'package:medical_hub/data/doctor_types.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/user/home/widgets/category_card.dart';
import 'package:page_transition/page_transition.dart';

import '../category/category_screen.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Ramzan",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    Text(
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
                    height: mq.width * .2,
                    width: mq.width * .2,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(Icons.person),
                    imageUrl: "http>>>>>>>>",
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
                height: mq.width * 0.6,

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
                            PageTransition(
                                child: CategoryScreen(
                                  categoryName: doctorTypes.keys
                                      .toList()[index]
                                      .toString(),
                                ),
                                type: PageTransitionType.scale,
                                alignment: Alignment.centerRight,
                                duration: const Duration(milliseconds: 1200)));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
        )
      ],
    );
  }
}
