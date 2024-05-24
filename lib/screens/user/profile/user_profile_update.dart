// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/user_apis.dart';

import 'package:medical_hub/constants.dart';
import 'package:medical_hub/data/cities.dart';
import 'package:medical_hub/data/doctor_types.dart';

import 'package:medical_hub/main.dart';

import 'package:medical_hub/models/user.dart';

import 'package:medical_hub/widgets/custom_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:medical_hub/screens/auth/login/validation_hub.dart';

class UserProfileUpdateScreen extends StatefulWidget {
  const UserProfileUpdateScreen({super.key});

  @override
  State<UserProfileUpdateScreen> createState() =>
      _UserProfileUpdateScreenState();
}

class _UserProfileUpdateScreenState extends State<UserProfileUpdateScreen> {
  final GlobalKey<FormState> _formState = GlobalKey();
  ValidationHub validationHub = ValidationHub();

  final TextEditingController _nameController = TextEditingController()
    ..text = UserApis.self.name;

  final TextEditingController _phoneController = TextEditingController()
    ..text = UserApis.self.phoneNumber;

  final TextEditingController _addressController = TextEditingController()
    ..text = UserApis.self.address;
  bool _selectedRadioValue = true;
  String? _selectedState;
  String? _selectedCity;

  late String profileImageURL = UserApis.self.imageUrl;

  bool _isProfileChanged = false;
  bool _isUpdating = false;

  void changeProfileVarState() {
    setState(() {
      _isProfileChanged = !_isProfileChanged;
    });
  }

  void updateProfileURL(String url) {
    profileImageURL = url;
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
        body: _isUpdating
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
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
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                          baseColor: const Color.fromARGB(
                                              255, 119, 115, 115),
                                          highlightColor: Colors.grey[300]!,
                                          child: const Icon(Icons.person)),
                                  imageUrl: profileImageURL,
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
                                  _showBottomSheet(changeProfileVarState,
                                      "profile", updateProfileURL);
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
                          UserApis.self.email,
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
                            // initialValue: "Ramzan",
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
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
                                  hint: UserApis.self.state == ""
                                      ? const Text("--select state--")
                                      : Text(UserApis.self.state),
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
                                  hint: UserApis.self.city == ""
                                      ? const Text("--select city--")
                                      : Text(UserApis.self.city),
                                  value: _selectedCity,
                                  items: _selectedState == null
                                      ? []
                                      : pakistanStatesAndCities[_selectedState]!
                                          .toList()
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value)))
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
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
                      ]),
                    ],
                  ),
                )),
        floatingActionButton: SizedBox(
          width: 100,
          child: FloatingActionButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formState.currentState != null &&
                  _formState.currentState!.validate()) {
                _formState.currentState!.save();

                if (_isProfileChanged || UserApis.self.imageUrl != "") {
                  if ((_selectedCity != null || UserApis.self.city != "") &&
                      (_selectedState != null || UserApis.self.state != "")) {
                    try {
                      setState(() {
                        _isUpdating = true;
                      });
                      await UserApis.updateUserProfile(User(
                          isUpdated: true,
                          likes: UserApis.self.likes.isEmpty
                              ? [""]
                              : UserApis.self.likes,
                          lastActive: "",
                          city: _selectedCity ?? UserApis.self.city,
                          state: _selectedState ?? UserApis.self.state,
                          id: APIs.user.uid,
                          name: _nameController.text.trim(),
                          email: APIs.user.email!,
                          imageUrl: profileImageURL,
                          phoneNumber: _phoneController.text.trim(),
                          isPhoneHidden: true,
                          isOnline: true,
                          createdAt: "",
                          address: _addressController.text,
                          gender: _selectedRadioValue));

                      setState(() {
                        _isUpdating = false;
                      });

                      CustomWidget.showSnackBar(
                          context, "Updated Successfully!");
                    } catch (e) {
                      CustomWidget.showSnackBar(context, e.toString());
                    }
                  } else {
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
                        String imageURL = await UserApis.getImageURL(
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
                        String imageURL = await UserApis.getImageURL(
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
