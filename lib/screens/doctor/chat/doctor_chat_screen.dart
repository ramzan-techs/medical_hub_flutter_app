import 'dart:developer';
import 'dart:io';

// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_hub/api/chat_apis.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/helper/my_date_util.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/models/user.dart';
import 'package:medical_hub/screens/profile_pic_view.dart';
import 'package:medical_hub/widgets/message_card.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/message.dart';

class DoctorChatScreen extends StatefulWidget {
  final User user;
  const DoctorChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  List<Message> _list = [];
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isEmojiShown = false, _isImageUploading = false;

  // to control back button when emoji is shown
  bool _emojiBackLogic() {
    if (_isEmojiShown) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_isEmojiShown) {
          setState(() {
            _isEmojiShown = !_isEmojiShown;
          });
        }
      },
      child: PopScope(
        canPop: _emojiBackLogic(),
        onPopInvoked: (didPop) {
          setState(() {
            _isEmojiShown = !_isEmojiShown;
          });
        },
        child: Scaffold(
          body: Container(
            height: mq.height,
            width: mq.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              Container(
                  height: mq.height * 0.12,
                  decoration: BoxDecoration(
                    color: Constants().secondaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: appBar()),
              Expanded(
                  child: StreamBuilder(
                stream: ChatApis.getAllMessages(widget.user.id),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: SizedBox(),
                      );

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: _list[index],
                              );
                            });
                      } else {
                        return const Center(
                          child: Text(
                            'Say Hii👋!',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                }),
              )),
              if (_isImageUploading)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              chatInputField(),
              if (_isEmojiShown)
                SizedBox(
                  height: mq.height * 0.3,
                  child: EmojiPicker(
                    textEditingController: _textEditingController,
                    scrollController: _scrollController,
                    config: Config(
                      height: mq.height * 0.3,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                      ),
                    ),
                  ),
                ),
              if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                SizedBox(
                  height: mq.height * 0.05,
                )
            ]),
          ),
        ),
      ),
    );
  }

  Widget chatInputField() {
    return Padding(
      padding: EdgeInsets.only(
          left: mq.width * 0.015,
          right: mq.width * 0.015,
          top: mq.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              // _currentLines == 1
              //     ? StadiumBorder()
              //     : RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _isEmojiShown = !_isEmojiShown;
                      });
                    },
                    icon: const Icon(Icons.emoji_emotions),
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (_isEmojiShown) {
                          setState(() {
                            _isEmojiShown = !_isEmojiShown;
                          });
                        }
                      },
                      controller: _textEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter message...',
                          hintStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),

                  // image picker from gallery
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var image in images) {
                          log('Image Path : ${image.path}');
                          setState(() {
                            _isImageUploading = true;
                          });
                          ChatApis.sendChatImage(widget.user.id,
                              File(image.path), widget.user.isOnline);
                          setState(() {
                            _isImageUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blue,
                      )),

                  // image picker from camera
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path : ${image.path}');
                          setState(() {
                            _isImageUploading = true;
                          });
                          ChatApis.sendChatImage(widget.user.id,
                              File(image.path), widget.user.isOnline);
                          setState(() {
                            _isImageUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.camera,
                        color: Colors.blue,
                      )),
                  const SizedBox(
                    width: 2,
                  )
                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(
            padding: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.025),
            minWidth: 0,
            onPressed: () {
              if (_textEditingController.text.trim().isNotEmpty) {
                ChatApis.sendMessage(
                    widget.user.id,
                    _textEditingController.text.trim(),
                    Type.text,
                    widget.user.isOnline);
                _textEditingController.text = "";
              }
            },
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }

  Widget appBar() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileDialog(
                              name: widget.user.name,
                              imageUrl: widget.user.imageUrl)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .33),
                  child: CachedNetworkImage(
                    height: mq.width * .14,
                    width: mq.width * .14,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[500]!,
                        highlightColor: Colors.grey[300]!,
                        child: const Icon(Icons.person)),
                    imageUrl: widget.user.imageUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  widget.user.isOnline
                      ? "Online"
                      : MyDateUtil.getLastActiveTime(
                          context: context, lastActive: widget.user.lastActive),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
