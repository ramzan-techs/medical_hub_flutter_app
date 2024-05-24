import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_hub/api/doctor_apis.dart';

import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/appointment.dart';

import 'package:medical_hub/models/user.dart';

class AppointmentCard extends StatefulWidget {
  final User user;
  final Appointment appointment;
  final Function? chatIconClick;
  const AppointmentCard({
    super.key,
    required this.user,
    this.chatIconClick,
    required this.appointment,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool isAcceptedOrDeclined = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => DoctorProfileView(doctor: doctor)));
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
                        imageUrl: widget.user.imageUrl,
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
                        Text(
                          widget.user.name,
                          style: TextStyle(
                              color: Constants().primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.user.city,
                          style: TextStyle(
                              color: Constants().primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 0),
                                    backgroundColor: const Color.fromARGB(
                                        255, 205, 255, 190)),
                                onPressed: () {},
                                child: Text(
                                    "${widget.appointment.date.day} ${DateFormat('MMMM').format(widget.appointment.date)},${DateFormat('E').format(widget.appointment.date)} ")),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    backgroundColor: const Color.fromARGB(
                                        255, 205, 255, 190)),
                                onPressed: () {},
                                child: Text(widget.appointment.time)),
                          ],
                        ),
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
                      Text(widget.appointment.statusUpdated
                          ? widget.appointment.approved
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              backgroundColor: Colors.lightGreen),
                          onPressed: widget.appointment.statusUpdated
                              ? null
                              : isAcceptedOrDeclined
                                  ? null
                                  : () async {
                                      setState(() {
                                        isAcceptedOrDeclined = true;
                                      });
                                      await DoctorApis.updateAppointmentStatus(
                                          widget.appointment.id, true);
                                    },
                          child: const Text("Accept")),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              backgroundColor: Colors.lightGreen),
                          onPressed: widget.appointment.statusUpdated
                              ? null
                              : isAcceptedOrDeclined
                                  ? null
                                  : () async {
                                      setState(() {
                                        isAcceptedOrDeclined = true;
                                      });
                                      await DoctorApis.updateAppointmentStatus(
                                          widget.appointment.id, false);
                                    },
                          child: const Text("Decline")),
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
