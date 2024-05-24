// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:medical_hub/api/doctor_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/data/cities.dart';
import 'package:medical_hub/data/doctor_types.dart';
import 'package:medical_hub/data/medical_degrees.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/doctor.dart';

import 'package:medical_hub/widgets/custom_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:medical_hub/screens/auth/login/validation_hub.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final GlobalKey<FormState> _formState = GlobalKey();
  ValidationHub validationHub = ValidationHub();

  final TextEditingController _nameController = TextEditingController()
    ..text = DoctorApis.self.isUpdated ? DoctorApis.self.name : "";
  final TextEditingController _phoneController = TextEditingController()
    ..text = DoctorApis.self.isUpdated ? DoctorApis.self.phone : "";
  final TextEditingController _registrationNoController =
      TextEditingController()
        ..text =
            DoctorApis.self.isUpdated ? DoctorApis.self.registrationNumber : "";
  final TextEditingController _addressController = TextEditingController()
    ..text = DoctorApis.self.isUpdated ? DoctorApis.self.address : "";
  bool _selectedRadioValue =
      DoctorApis.self.isUpdated ? DoctorApis.self.gender : true;
  String? _selectedState;
  // DoctorApis.self.isUpdated ? DoctorApis.self.state : null;
  String? _selectedCity;
  // DoctorApis.self.isUpdated ? DoctorApis.self.city : null;
  String? _selectedQualification;
  // DoctorApis.self.isUpdated ? DoctorApis.self.qualification : null;
  String? _selectedSpecialization;
  // DoctorApis.self.isUpdated ? DoctorApis.self.qualification : null;

  final List<String> _availableDays = [];
  final List<String> _availableTime = [];

  late String profileImageURL =
      DoctorApis.self.isUpdated ? DoctorApis.self.profileImageUrl : "";
  late String cnicImageURL =
      DoctorApis.self.isUpdated ? DoctorApis.self.cnicImageUrl : "";
  late String liscenceImageURL =
      DoctorApis.self.isUpdated ? DoctorApis.self.licenseImageUrl : "";
  List<String> visitingDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List<String> visitingTimes = [
    "01:00 AM",
    "02:00 AM",
    "03:00 AM",
    "04:00 AM",
    "05:00 AM",
    "06:00 AM",
    "07:00 AM",
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
    "09:00 PM",
    "10:00 PM",
    "11:00 PM",
    "12:00 AM"
  ];

  bool _isProfileChanged = DoctorApis.self.isUpdated ? true : false;
  bool _isCnicUploaded = DoctorApis.self.isUpdated ? true : false;
  bool _isLiscenceUploaded = DoctorApis.self.isUpdated ? true : false;

  void changeProfileVarState() {
    setState(() {
      _isProfileChanged = !_isProfileChanged;
    });
  }

  void changeCnicVarState() {
    setState(() {
      _isCnicUploaded = !_isCnicUploaded;
    });
  }

  void changeLiscenceVarState() {
    setState(() {
      _isLiscenceUploaded = !_isLiscenceUploaded;
    });
  }

  void updateProfileURL(String url) {
    profileImageURL = url;
  }

  void updateCnicURL(String url) {
    cnicImageURL = url;
  }

  void updateLiscenceURL(String url) {
    liscenceImageURL = url;
  }

  List<String> getSpecialiizationList() {
    final list = doctorTypes.keys.toList();
    List<String> mainList = [];
    for (int i = 0; i < list.length; i++) {
      mainList.addAll(doctorTypes[list[i]]!.toList());
    }

    return mainList;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _registrationNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
          shadowColor: Constants().primaryColor,
          elevation: 2,
        ),
        body: Form(
            key: _formState,
            child: Center(
              child: ListView(
                children: [
                  Column(children: [
                    SizedBox(
                      width: mq.width,
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(mq.height * .33),
                            border: Border.all(color: Colors.greenAccent),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * .33),
                            child: CachedNetworkImage(
                              height: mq.width * .4,
                              width: mq.width * .4,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 119, 115, 115),
                                  highlightColor: Colors.grey[300]!,
                                  child: const Icon(Icons.person)),
                              imageUrl: DoctorApis.self.isUpdated
                                  ? DoctorApis.self.profileImageUrl
                                  : _isProfileChanged
                                      ? profileImageURL
                                      : "http//www.google.com/",
                              errorWidget: (context, url, error) =>
                                  const Icon(CupertinoIcons.person),
                            ),
                          ),
                        ),
                        Positioned(
                          //profile change button
                          bottom: 0,
                          right: -20,
                          child: MaterialButton(
                            shape: const CircleBorder(),
                            onPressed: () {
                              _showBottomSheet(changeProfileVarState, "profile",
                                  updateProfileURL);
                            },
                            color: Colors.white,
                            child: const Icon(Icons.edit),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      DoctorApis.self.email,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 6,
                    ),

                    // ******** for name ********** //
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Full Name',
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          } else if (validationHub
                              .isValidFullName(value.trim())) {
                            return null;
                          } else {
                            return 'Only alphabets allow!';
                          }
                        },
                      ),
                    ),

                    // ********** number field ************* //

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: '03XXXXXXXXX',
                          suffixIcon: Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          } else if (validationHub
                              .validatePhoneNumber(value.trim())) {
                            return null;
                          } else {
                            return 'Invalid Phone number!';
                          }
                        },
                      ),
                    ),

                    // ************** Gender *********** //

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      child: Row(
                        children: [
                          const Text(
                            "Gender:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Radio(
                              value: true,
                              groupValue: _selectedRadioValue,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRadioValue = value!;
                                });
                              }),
                          const Text(
                            "Male",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Radio(
                              value: false,
                              groupValue: _selectedRadioValue,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRadioValue = value!;
                                });
                              }),
                          const Text(
                            "Female",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ************** registeration number ************** //

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: TextFormField(
                        controller: _registrationNoController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Registration Number',
                          suffixIcon: Icon(
                            Icons.assignment,
                            color: Colors.green,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    // *************** city and State fields ********************* //

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "State:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          DropdownButton(
                              // ******* states ********** //
                              hint: const Text("--select state--"),
                              value: _selectedState,
                              items: pakistanStatesAndCities.keys
                                  .toList()
                                  .map((String value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value!;
                                  _selectedCity = null;
                                });
                              }),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "City:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          DropdownButton(
                              menuMaxHeight: mq.height * 0.5,
                              // ******* cities ********** //
                              hint: const Text("--select city--"),
                              value: _selectedCity,
                              items: _selectedState == null
                                  ? []
                                  : pakistanStatesAndCities[_selectedState]!
                                      .toList()
                                      .map((String value) => DropdownMenuItem(
                                          value: value, child: Text(value)))
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value.toString();
                                });
                              }),
                        ],
                      ),
                    ),

                    // ********************** Address Field *********************//

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Address',
                          suffixIcon: Icon(
                            Icons.home,
                            color: Colors.green,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    // ********************** Qualification ****************** ///

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Qualification:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          DropdownButton(
                              menuMaxHeight: mq.height * 0.4,

                              // ******* education ********** //
                              hint: const Text("Select Qualification"),
                              value: _selectedQualification,
                              items: medicalQualificationsPakistan
                                  .map((String value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedQualification = value!;
                                });

                                log(_selectedQualification!);
                              }),
                        ],
                      ),
                    ),

                    // *********************** Specialization **************** //

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                          ),
                          const Text(
                            "Specialization:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          DropdownButton(
                              menuMaxHeight: mq.height * 0.4,
                              isExpanded: true,
                              // ******* speciality ********** //
                              hint: const Text("--Specialization--"),
                              value: _selectedSpecialization,
                              items: getSpecialiizationList()
                                  .map((String value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSpecialization = value!;
                                });

                                log(_selectedSpecialization!);
                              }),
                        ],
                      ),
                    ),

                    // available times

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            const Text("Select visiting time:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                                height: mq.height * 0.22,
                                child: GridView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemCount: visitingTimes.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 0,
                                            childAspectRatio: 2),
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor:
                                                _availableTime.contains(
                                                        visitingTimes[index])
                                                    ? Colors.lightGreen
                                                    : Colors.white70,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical:
                                                    10.0), // Adjust padding
                                          ),
                                          onPressed: () {
                                            // Handle button press
                                            setState(() {
                                              if (_availableTime.contains(
                                                  visitingTimes[index])) {
                                                _availableTime.remove(
                                                    visitingTimes[index]);
                                              } else {
                                                _availableTime
                                                    .add(visitingTimes[index]);
                                              }
                                            });
                                          },
                                          child: Text(
                                            visitingTimes[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            const Text("Select  visiting days:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                                height: mq.height * 0.22,
                                child: GridView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemCount: visitingDays.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 0,
                                            childAspectRatio: 2),
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor:
                                                _availableDays.contains(
                                                        visitingDays[index])
                                                    ? Colors.lightGreen
                                                    : Colors.white70,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical:
                                                    10.0), // Adjust padding
                                          ),
                                          onPressed: () {
                                            // Handle button press
                                            setState(() {
                                              if (_availableDays.contains(
                                                  visitingDays[index])) {
                                                _availableDays.remove(
                                                    visitingDays[index]);
                                              } else {
                                                _availableDays
                                                    .add(visitingDays[index]);
                                              }
                                            });
                                          },
                                          child: Text(
                                            visitingDays[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                        ),
                      ),
                    ),

                    // *********************** CNIC Picture ***************** ///

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "CNIC Front Side Pic:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: mq.width * 0.9,
                                height: mq.height * 0.25,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10)),
                                child: (_isCnicUploaded ||
                                        DoctorApis.self.isUpdated)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: mq.width * .4,
                                          width: mq.width * .4,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                  baseColor:
                                                      const Color.fromARGB(
                                                          255, 119, 115, 115),
                                                  highlightColor:
                                                      Colors.grey[300]!,
                                                  child:
                                                      const Icon(Icons.person)),
                                          imageUrl: DoctorApis.self.isUpdated
                                              ? DoctorApis.self.cnicImageUrl
                                              : cnicImageURL,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.image),
                                        ),
                                      )
                                    : Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              _showBottomSheet(
                                                  changeCnicVarState,
                                                  "cnic",
                                                  updateCnicURL);
                                            },
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.upload_file,
                                                  size: 60,
                                                ),
                                                Text("Upload Pic")
                                              ],
                                            )),
                                      ),
                              ),
                              if ((_isCnicUploaded ||
                                  DoctorApis.self.isUpdated))
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    child: GestureDetector(
                                        onTap: () {
                                          _showBottomSheet(changeCnicVarState,
                                              "cnic", updateCnicURL);
                                        },
                                        child: const Icon(
                                          Icons.edit_document,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ********************** Liscence Picture ********************** //

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Liscence Picture:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: mq.width * 0.9,
                                height: mq.height * 0.25,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10)),
                                child: (_isLiscenceUploaded ||
                                        DoctorApis.self.isUpdated)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: mq.width * .4,
                                          width: mq.width * .4,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                  baseColor:
                                                      const Color.fromARGB(
                                                          255, 119, 115, 115),
                                                  highlightColor:
                                                      Colors.grey[300]!,
                                                  child:
                                                      const Icon(Icons.person)),
                                          imageUrl: DoctorApis.self.isUpdated
                                              ? DoctorApis.self.licenseImageUrl
                                              : liscenceImageURL,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.image),
                                        ),
                                      )
                                    : Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              _showBottomSheet(
                                                  changeLiscenceVarState,
                                                  "liscence",
                                                  updateLiscenceURL);
                                            },
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.upload_file,
                                                  size: 60,
                                                ),
                                                Text("Upload Pic")
                                              ],
                                            )),
                                      ),
                              ),
                              if ((_isLiscenceUploaded ||
                                  DoctorApis.self.isUpdated))
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    child: GestureDetector(
                                        onTap: () {
                                          _showBottomSheet(
                                              changeLiscenceVarState,
                                              "liscence",
                                              updateLiscenceURL);
                                        },
                                        child: const Icon(
                                          Icons.edit_document,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            )),
        floatingActionButton: SizedBox(
          width: 100,
          child: FloatingActionButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Constants().primaryColor,
                      ),
                    );
                  });
              if (_formState.currentState != null &&
                  _formState.currentState!.validate()) {
                _formState.currentState!.save();

                if (_isCnicUploaded &&
                    _isLiscenceUploaded &&
                    _isProfileChanged) {
                  if (_selectedCity != null &&
                      _selectedQualification != null &&
                      _selectedSpecialization != null &&
                      _selectedState != null) {
                    try {
                      await DoctorApis.updateDoctorProfile(Doctor(
                          availableTime: _availableTime,
                          availableDays: _availableDays,
                          isUpdated: true,
                          isReviewed: false,
                          isApproved: false,
                          lastActive: "",
                          id: "",
                          registrationNumber:
                              _registrationNoController.text.toString().trim(),
                          name: _nameController.text.toString().trim(),
                          speciality: _selectedSpecialization!,
                          profileImageUrl: profileImageURL,
                          email: "",
                          favoritesCount: 0,
                          isOnline: false,
                          createdAt: "",
                          phone: _phoneController.text.toString().trim(),
                          gender: _selectedRadioValue,
                          state: _selectedState!,
                          city: _selectedCity!,
                          address: _addressController.text.toString().trim(),
                          cnicImageUrl: cnicImageURL,
                          licenseImageUrl: liscenceImageURL,
                          qualification: _selectedQualification!));

                      Navigator.pop(context);

                      CustomWidget.showSnackBar(
                          context, "Updated Successfully!");
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                      CustomWidget.showSnackBar(context, e.toString());
                    }
                  } else {
                    Navigator.pop(context);
                    CustomWidget.showSnackBar(
                        context, "Please select all DropDown values");
                  }
                } else {
                  CustomWidget.showSnackBar(
                      context, "Please upload all pictures");
                }
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.update), Text("Update")],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(void Function() changeVarState, String imgName,
      void Function(String) updateURL) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Text(
                "Pick ${imgName.toUpperCase()} Picture",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 50);

                      if (image != null) {
                        log('Image Path : ${image.path}');
                        CustomWidget.showProgressBar(context);
                        String imageURL = await DoctorApis.getImageURL(
                            File(image.path), "profile");

                        Navigator.pop(context);
                        Navigator.pop(context);

                        CustomWidget.showSnackBar(
                            context, 'Pic Uploaded Scuccessfuly!');
                        setState(() {
                          changeVarState();
                          updateURL(imageURL);
                        });
                      }
                    },
                    child: Image.asset(
                      'assets/images/gallery.png',
                      height: mq.height * .15,
                      width: mq.width * .25,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                      if (image != null) {
                        log('Image Path : ${image.path}');
                        CustomWidget.showProgressBar(context);
                        String imageURL = await DoctorApis.getImageURL(
                            File(image.path), "profile");

                        Navigator.pop(context);
                        Navigator.pop(context);

                        CustomWidget.showSnackBar(
                            context, 'Pic Uploaded Scuccessfuly!');
                        setState(() {
                          changeVarState();
                          updateURL(imageURL);
                        });
                      }
                    },
                    child: Image.asset(
                      'assets/images/camera.png',
                      height: mq.height * .15,
                      width: mq.width * .25,
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
