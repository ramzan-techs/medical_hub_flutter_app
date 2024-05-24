// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';

import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/widgets/custom_widgets.dart';
import 'package:shimmer/shimmer.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDate = 0;
  String _selectedTime = "";
  DateTime currentDate = DateTime.now();
  // List<DateTime> generateDates(int numberOfDays) {
  //   DateTime currentDate = DateTime.now();
  //   return List.generate(numberOfDays, (index) {
  //     return currentDate.add(Duration(days: index));
  //   });
  // }

  // Generate a list of dates starting from today for the next `numberOfDays` days.
  List<DateTime> generateDates(int numberOfDays, List<String> daysName) {
    DateTime currentDate = DateTime.now();
    List<DateTime> dateList = [];
    while (dateList.length < numberOfDays) {
      if (daysName.contains(DateFormat('EEEE').format(currentDate))) {
        dateList.add(currentDate);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return dateList;
  }

  List<DateTime>? dateList;
  List<String> visitingTimes = [];
  // Generate a list of the next 30 days

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    visitingTimes = widget.doctor.availableTime;
    dateList = generateDates(10, widget.doctor.availableDays);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Constants().primaryColor,
                  ),
                );
              });
          try {
            await UserApis.addAppointment(
                widget.doctor, _selectedTime, dateList![_selectedDate]);

            Navigator.pop(context);
            CustomWidget.showSnackBar(context, "Appointment Submited");
            Navigator.pop(context);
          } catch (e) {
            CustomWidget.showSnackBar(context, e.toString());
          }
        },
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        label: const Text(
          "Book",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
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
                          "Book Appointment",
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
          ),

          SizedBox(
            height: mq.width * 0.15,
          ),

          // body /////////////////

          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
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
                              "Dr. ${widget.doctor.name}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.doctor.speciality,
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: mq.height * 0.01,
                            ),
                            SizedBox(
                              width: mq.width * 0.8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "About Doctor",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  Text(
                                    "Dr. ${widget.doctor.name} is a professional ${widget.doctor.speciality}.He is from ${widget.doctor.city} and acquired the degree of ${widget.doctor.qualification} from high reputed university.",
                                    maxLines: null,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Shedules",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: mq.height * 0.12,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: dateList!.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedDate = index;
                                                // print(_selectedDate);
                                              });
                                            },
                                            child: Card(
                                              color: _selectedDate == index
                                                  ? Colors.lightGreen
                                                  : Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 120,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          dateList![index]
                                                              .day
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          DateFormat('E')
                                                              .format(dateList![
                                                                  index]),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: mq.width * 0.8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Visit Hour",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  SizedBox(
                                      height: mq.height * 0.22,
                                      child: GridView.builder(
                                          padding: const EdgeInsets.all(0),
                                          itemCount: visitingTimes.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: 2),
                                          itemBuilder: (context, index) {
                                            return Center(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: const StadiumBorder(),
                                                  backgroundColor:
                                                      _selectedTime ==
                                                              visitingTimes[
                                                                  index]
                                                          ? Colors.lightGreen
                                                          : Colors.white70,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical:
                                                          10.0), // Adjust padding
                                                ),
                                                onPressed: () {
                                                  // Handle button press
                                                  setState(() {
                                                    _selectedTime =
                                                        visitingTimes[index];
                                                  });
                                                },
                                                child: Text(
                                                  visitingTimes[index],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            );
                                          })),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -(mq.width * 0.2),
                        left: mq.width * 0.27,
                        child: Container(
                          height: mq.width * .4,
                          width: mq.width * .4,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Constants().primaryColor),
                              borderRadius:
                                  BorderRadius.circular(mq.height * .33)),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * .33),
                            child: CachedNetworkImage(
                              height: mq.width * .4,
                              width: mq.width * .4,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.lightGreen,
                                  child: const Text("")),
                              imageUrl: widget.doctor.profileImageUrl,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
