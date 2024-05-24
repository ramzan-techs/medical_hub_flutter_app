import 'package:cached_network_image/cached_network_image.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/helper/my_date_util.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/message.dart';

import 'package:medical_hub/models/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/chat_apis.dart';
import 'package:medical_hub/screens/doctor/chat/doctor_chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final User user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * .02,
        vertical: 4,
      ),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DoctorChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: ChatApis.getLastMessages(widget.user.id),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              //user profile pic
              leading: InkWell(
                // onTap: () {
                //   showDialog(
                //       context: context,
                //       builder: (_) => ProfileDialog(
                //             user: widget.user,
                //           ));
                // },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: mq.height * .055,
                    width: mq.height * .055,
                    placeholder: (context, url) => const Icon(Icons.person),
                    imageUrl: widget.user.imageUrl,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
              ),

              //user name
              title: Text(widget.user.name),

              //user last message in chat
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_message != null)
                    _message!.fromId != APIs.user.uid
                        ? const SizedBox()
                        : _message!.read.isEmpty
                            ? _message!.recieved.isEmpty
                                ? const Icon(
                                    Icons.done,
                                    size: 15,
                                  )
                                : const Icon(
                                    Icons.done_all_rounded,
                                    size: 15,
                                  )
                            : const Icon(
                                Icons.done_all_rounded,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                  _message != null
                      ? _message!.type == Type.text
                          ? Text(
                              _message!.msg.length > 20
                                  ? '${_message!.msg.substring(0, 20)}...'
                                  : _message!.msg,
                            )
                          : const Text("Image")
                      : const Text("No Chat Found!"),
                ],
              ),

              //time of last message
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.black45),
                        ),
            );
          },
        ),
      ),
    );
  }
}
