import 'package:flutter/material.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/chat_apis.dart';

import 'package:medical_hub/models/user.dart';
import 'package:medical_hub/screens/doctor/chat/chat_user_card.dart';

import '../../../constants.dart';
import '../../../main.dart';

class DoctorChatsScreen extends StatefulWidget {
  const DoctorChatsScreen({super.key});

  @override
  State<DoctorChatsScreen> createState() => _DoctorChatsScreenState();
}

class _DoctorChatsScreenState extends State<DoctorChatsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _isTapped = false;
  final List<User> _searchList = [];

  // to store chat user data list
  List<User> _list = [];

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
    return Column(
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
                          SizedBox(
                            width: mq.width * 0.09,
                          ),
                          Text(
                            "Chats",
                            style: TextStyle(
                                color: Constants().onPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
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
                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(value.toLowerCase())) {
                        _searchList.add(i);
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
                    hintText: "Search...",
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

        // Stream data ************************************
        // ************************************************
        Flexible(
          child: StreamBuilder(
              stream:
                  ChatApis.getAllMessageUsersIdInfo('doctors', APIs.user.uid),
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
                        stream: ChatApis.getAllMessageUersInfo(
                            snapshot.data!.docs.map((e) => e.id).toList(),
                            'users'),
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
                              _list = data
                                      ?.map((e) => User.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                    padding:
                                        EdgeInsets.only(top: mq.height * 0.01),
                                    itemCount: _isTyping
                                        ? _searchList.length
                                        : _list.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                        user: _isTyping
                                            ? _searchList[index]
                                            : _list[index],
                                      );
                                    });
                              } else {
                                return const Center(
                                  child: Text(
                                    'No Chat Found!',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }
                          }
                        }));
                }
              }),
        )
      ],
    );
  }
}
