import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medical_hub/models/doctor.dart';

import '../api/apis.dart';
import '../models/message.dart';

class ChatApis {
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessageUsersIdInfo(
      String col, String id) {
    return APIs.firestore
        .collection(col)
        .doc(id)
        .collection('chatUsers')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessageUersInfo(
      List<String> ids, String col) {
    return APIs.firestore
        .collection(col)
        .where('id', whereIn: ids.isEmpty ? ["null"] : ids)
        .snapshots();
  }

  static String getConversationId(String id) =>
      APIs.user.uid.hashCode <= id.hashCode
          ? '${APIs.user.uid}_$id'
          : '${id}_${APIs.user.uid}';

  // for getting all messages from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String chatUserId) {
    return APIs.firestore
        .collection('chats/${getConversationId(chatUserId)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(
      String chatUserId, String msg, Type type, bool isOnline) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to be send
    final Message message = Message(
        toId: chatUserId,
        read: "",
        type: type,
        sent: time,
        fromId: APIs.user.uid,
        msg: msg,
        recieved: "");

    final ref = APIs.firestore
        .collection('chats/${getConversationId(chatUserId)}/messages');
    await ref.doc(time).set(message.toJson());
  }

  // for updating read time of message
  static Future<void> updateMessageReadStatus(Message message) async {
    APIs.firestore
        .collection('chats/${getConversationId(message.fromId)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // for getting last message from chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      String chatUserId) {
    return APIs.firestore
        .collection('chats/${getConversationId(chatUserId)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // for sending images in chat
  static Future<void> sendChatImage(
      String chatUserId, File file, bool isOnline) async {
    //getting extension of image
    final ext = file.path.split('.').last;
    final ref = APIs.storage.ref().child(
        'images/${getConversationId(chatUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Image data : ${p0.bytesTransferred / 1000} kb');
    });

    //updating image url in user data
    final imageUrl = await ref.getDownloadURL();

    await sendMessage(chatUserId, imageUrl, Type.image, isOnline);
  }

  static Future<void> addInboxUsers(Doctor doctor) async {
    await APIs.firestore
        .collection('users')
        .doc(APIs.user.uid)
        .collection('chatUsers')
        .doc(doctor.id)
        .set({'id': doctor.id});
  }
}
