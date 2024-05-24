import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/appointment.dart';

import 'package:medical_hub/models/user.dart';
import 'package:medical_hub/screens/doctor/appointment/appointment_card.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  List<Appointment> _listAppointments = [];
  final List<String> _usersIds = [];
  List<User> _usersInfo = [];

  void getUserIds() {
    for (int i = 0; i < _listAppointments.length; i++) {
      _usersIds.add(_listAppointments[i].patientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: mq.width,
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Container(
            height: mq.height * 0.11,
            decoration: BoxDecoration(
              color: Constants().secondaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Appointments",
                    style: TextStyle(
                        color: Constants().onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: // Stream data ************************************
                // ************************************************
                StreamBuilder(
                    stream: UserApis.getAllAppointmentIdsInfo(
                        'doctors', APIs.user.uid),
                    builder: (context, snapshot) {
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
                          return StreamBuilder(
                              stream: UserApis.getAppointments(
                                snapshot.data!.docs.map((e) => e.id).toList(),
                              ),
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
                                    final data = snapshot.data?.docs;
                                    _listAppointments = data
                                            ?.map((e) =>
                                                Appointment.fromJson(e.data()))
                                            .toList() ??
                                        [];

                                    if (_listAppointments.isNotEmpty) {
                                      getUserIds();
                                      return StreamBuilder(
                                          stream: UserApis
                                              .getAllAppointmentUsersInfo(
                                                  _usersIds),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              // if data is loading
                                              case ConnectionState.waiting:
                                              case ConnectionState.none:
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );

                                              //if all or some data is loaded show it
                                              case ConnectionState.active:
                                              case ConnectionState.done:
                                                final doctorData =
                                                    snapshot.data!.docs;

                                                _usersInfo = doctorData
                                                    .map((e) =>
                                                        User.fromJson(e.data()))
                                                    .toList();

                                                return ListView.builder(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0,
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 10),
                                                    itemCount: _listAppointments
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return AppointmentCard(
                                                          user:
                                                              _usersInfo[index],
                                                          appointment:
                                                              _listAppointments[
                                                                  index]);
                                                    });
                                            }
                                          });
                                    } else {
                                      return const Center(
                                        child: Text(
                                          'No Appointments Found',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }
                                }
                              }));
                      }
                    }))
      ],
    );
  }
}
