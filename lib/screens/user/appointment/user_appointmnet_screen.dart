import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/appointment.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/screens/user/appointment/appointment_card.dart';

class UserAppointmentsScreen extends StatefulWidget {
  const UserAppointmentsScreen({super.key});

  @override
  State<UserAppointmentsScreen> createState() => _UserAppointmentsScreenState();
}

class _UserAppointmentsScreenState extends State<UserAppointmentsScreen> {
  List<Appointment> _listAppointments = [];
  final List<String> _doctorIds = [];
  List<Doctor> _doctorsInfo = [];

  void getDoctorIds() {
    for (int i = 0; i < _listAppointments.length; i++) {
      _doctorIds.add(_listAppointments[i].doctorId);
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
            stream: UserApis.getAllAppointmentIdsInfo('users', APIs.user.uid),
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
                                    ?.map((e) => Appointment.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_listAppointments.isNotEmpty) {
                              getDoctorIds();
                              return StreamBuilder(
                                  stream: UserApis.getAllAppointmentDoctorsInfo(
                                      _doctorIds),
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
                                        final doctorData = snapshot.data!.docs;

                                        _doctorsInfo = doctorData
                                            .map((e) =>
                                                Doctor.fromJson(e.data()))
                                            .toList();

                                        return ListView.builder(
                                            padding: const EdgeInsets.only(
                                                top: 0,
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            itemCount: _listAppointments.length,
                                            itemBuilder: (context, index) {
                                              return AppointmentCard(
                                                  doctor: _doctorsInfo[index],
                                                  appointment:
                                                      _listAppointments[index]);
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
            },
          ),
        )
      ],
    );
  }
}
