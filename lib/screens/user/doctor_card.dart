import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/chat_apis.dart';

import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/screens/user/appointment/book_appointment_screen.dart';
import 'package:medical_hub/screens/user/chat/user_chat_screen.dart';
import 'package:medical_hub/screens/user/doctor_profile_view.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final Function? chatIconClick;
  const DoctorCard({
    super.key,
    required this.doctor,
    this.chatIconClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DoctorProfileView(doctor: doctor)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Constants().primaryColor)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        height: mq.width * .25,
                        width: mq.width * .25,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(Icons.person),
                        imageUrl: doctor.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: mq.width * 0.525,
                              child: Text(
                                "Dr. ${doctor.name}",
                                maxLines: null,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Constants().primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  UserApis.handleLike(doctor);
                                },
                                child: UserApis.self.likes.contains(doctor.id)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.blue,
                                      )
                                    : const Icon(Icons.favorite_border)),
                          ],
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            doctor.speciality,
                            style: TextStyle(
                                color: Constants().primaryColor,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            doctor.city,
                            style: TextStyle(
                                color: Constants().primaryColor,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 95,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.greenAccent),
                      child: Center(
                          child: Text("Likes: ${doctor.favoritesCount}"))),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              backgroundColor: Colors.lightGreen),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BookAppointmentScreen(doctor: doctor)));
                          },
                          child: const Text("Appointment")),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.lightGreen),
                          onPressed: () async {
                            await ChatApis.addInboxUsers(doctor);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        UserChatScreen(doctor: doctor)));
                          },
                          child: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble_2_fill,
                                // color: Constants().primaryColor,
                              ),
                              Text("Chat")
                            ],
                          ))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
