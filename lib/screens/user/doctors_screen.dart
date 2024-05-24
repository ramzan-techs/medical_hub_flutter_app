import 'package:flutter/material.dart';
import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/constants.dart';

import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/screens/user/doctor_card.dart';

class DoctorsScreen extends StatefulWidget {
  final String? categoryName;
  const DoctorsScreen({super.key, this.categoryName});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _isTapped = false;
  final List<Doctor> _searchList = [];
  List<Doctor> _currentList = [];

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _textEditingController.text.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isTapped = _focusNode.hasFocus;
    });
  }

  void _clearTextFieldAndUnfocus() {
    _textEditingController.clear();
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: mq.height * 0.15,
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
                                "Find Doctors",
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
                Positioned(
                  bottom: 10,
                  right: mq.width * 0.1,
                  child: Container(
                    width: mq.width * 0.8,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 43, 54, 45),
                        blurRadius: 40,
                        spreadRadius: 1,
                      )
                    ]),

                    //    Search Field ///////

                    child: TextField(
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      onChanged: (value) {
                        _searchList.clear();

                        for (Doctor doctor in _currentList) {
                          if (doctor.name
                              .toLowerCase()
                              .contains(value.trim().toLowerCase())) {
                            _searchList.add(doctor);
                          }

                          setState(() {
                            _searchList;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                        suffixIcon: _isTapped
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _clearTextFieldAndUnfocus();
                                },
                              )
                            : null,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Search by name...",
                        hintStyle: const TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                )
              ],
            ),

            // body /////////////////

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.categoryName == null
                          ? "All Doctors"
                          : widget.categoryName!,
                      style: TextStyle(
                        fontSize: 24,
                        color: Constants().secondaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // ************************************
                    // Stream builder ********************

                    Expanded(
                        child: StreamBuilder(
                            stream: widget.categoryName == null
                                ? UserApis.getAllDoctorsInfo()
                                : UserApis.getSpecificDoctorsInfo(
                                    widget.categoryName!),
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
                                  final data = snapshot.data!.docs;

                                  _currentList = data
                                      .map((e) => Doctor.fromJson(e.data()))
                                      .toList();

                                  if (_currentList.isNotEmpty) {
                                    return ListView.builder(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        itemCount: _isTyping
                                            ? _searchList.length
                                            : _currentList.length,
                                        itemBuilder: (context, index) {
                                          return DoctorCard(
                                            doctor: _isTyping
                                                ? _searchList[index]
                                                : _currentList[index],
                                          );
                                        });
                                  } else {
                                    return const Center(
                                      child: Text("No Doctor Found"),
                                    );
                                  }
                              }
                            }))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
