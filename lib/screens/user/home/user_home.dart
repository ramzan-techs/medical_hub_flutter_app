import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/user/home/widgets/category_card.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 22, 110, 25),
            borderRadius: BorderRadius.only(
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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: mq.width,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Browse by Category",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 22, 110, 25)),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: mq.width * 0.36,
                  // Constrain the height of the ListView
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      // Build your list item here
                      return CategoryCard();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
