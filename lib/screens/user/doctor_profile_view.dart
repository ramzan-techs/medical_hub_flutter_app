import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/helper/my_date_util.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/screens/profile_pic_view.dart';
import 'package:medical_hub/screens/user/appointment/book_appointment_screen.dart';
import 'package:medical_hub/screens/user/chat/user_chat_screen.dart';
import 'package:shimmer/shimmer.dart';

class DoctorProfileView extends StatelessWidget {
  final Doctor doctor;
  const DoctorProfileView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: mq.width,
          ),

          // Top decoration .....................
          // ....................................

          Container(
            height: mq.height * 0.12,
            decoration: BoxDecoration(
              color: Constants().secondaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.chevron_left,
                          size: 40,
                          color: Constants().onPrimary,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Dr. ${doctor.name}",
                        style: TextStyle(
                            color: Constants().onPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // body .......................
          // ............................

          SizedBox(
            height: mq.height * 0.12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  child: Column(
                    children: [
                      SizedBox(
                        width: mq.width,
                        height: mq.width * 0.212,
                      ),
                      Text(
                        "Dr. ${doctor.name}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        doctor.speciality,
                        style: const TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: mq.height * 0.03,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: mq.width * 0.86,
                        decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black38))),
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.76,
                              child: Text(
                                "${doctor.address}, ${doctor.city}, ${doctor.state} ",
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Phone Container ****************
                      // **********************************
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: mq.width * 0.86,
                        decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black38))),
                        child: Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.76,
                              child: Text(
                                doctor.phone,
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Education Container ***********************
                      // ***************************************

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: mq.width * 0.86,
                        decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black38))),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/education.png",
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.76,
                              child: Text(
                                doctor.qualification,
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Likes Container ************************
                      // ****************************************

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: mq.width * 0.86,
                        decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black38))),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite_outline_rounded),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.76,
                              child: Text(
                                "Favourite of ${doctor.favoritesCount} people",
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Membership date container ***********************
                      //  ************************************************

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: mq.width * 0.86,
                        decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black38))),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.76,
                              child: Text(
                                "Member since ${MyDateUtil.getformattedDate(context: context, time: doctor.createdAt, showDate: true)}",
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: mq.width,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              width: mq.width * 0.55,
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12))),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BookAppointmentScreen(
                                              doctor: doctor)));
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month),
                                    Text(
                                      "Appointment",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            UserChatScreen(doctor: doctor)));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                width: mq.width * 0.372,
                                decoration: BoxDecoration(
                                    color: Constants().secondaryTextColor,
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(12))),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.chat_bubble_2_fill,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Chat",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -(mq.width * 0.2),
                  left: mq.width * 0.27,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileDialog(
                                  name: doctor.name,
                                  imageUrl: doctor.profileImageUrl)));
                    },
                    child: Container(
                      height: mq.width * .4,
                      width: mq.width * .4,
                      decoration: BoxDecoration(
                          border: Border.all(color: Constants().primaryColor),
                          borderRadius: BorderRadius.circular(mq.height * .33)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .33),
                        child: CachedNetworkImage(
                          height: mq.width * .4,
                          width: mq.width * .4,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.lightGreen,
                              child: const Text("")),
                          imageUrl: doctor.profileImageUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
