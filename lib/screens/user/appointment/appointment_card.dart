import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/appointment.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/screens/user/doctor_profile_view.dart';

class AppointmentCard extends StatelessWidget {
  final Doctor doctor;
  final Appointment appointment;
  final Function? chatIconClick;
  const AppointmentCard({
    super.key,
    required this.doctor,
    this.chatIconClick,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => DoctorProfileView(doctor: doctor)));
      },
      child: GestureDetector(
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
                          placeholder: (context, url) =>
                              const Icon(Icons.person),
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
                          SizedBox(
                            width: mq.width * 0.55,
                            child: Text(
                              "Dr. ${doctor.name}",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Constants().primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 100,
                        ),
                        const Text(
                          "Status:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(appointment.statusUpdated
                            ? appointment.approved
                                ? "Accepted"
                                : "Declined"
                            : "Not Viewed Yet"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                backgroundColor: Colors.lightGreen),
                            onPressed: () {},
                            child: Text(
                                "${appointment.date.day} ${DateFormat('MMMM').format(appointment.date)},${DateFormat('E').format(appointment.date)} ")),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.lightGreen),
                            onPressed: () {},
                            child: Text(appointment.time)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class $ {}
