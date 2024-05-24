import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medical_hub/api/apis.dart';
import 'package:medical_hub/api/chat_apis.dart';
import 'package:medical_hub/api/doctor_apis.dart';
import 'package:medical_hub/models/appointment.dart';
import 'package:medical_hub/models/doctor.dart';
import 'package:medical_hub/models/user.dart';

class UserApis {
  static User self = User(
      isUpdated: true,
      lastActive: "",
      id: APIs.user.uid,
      name: "name",
      email: APIs.user.email!,
      imageUrl: "imageUrl",
      phoneNumber: "phoneNumber",
      isPhoneHidden: true,
      createdAt: "createdAt",
      state: "state",
      address: "address",
      gender: true,
      city: "city",
      isOnline: true,
      likes: ["hello"].toList());

  // to get user info current user
  static Future<void> getUserInfo() async {
    await APIs.firestore
        .collection('users')
        .doc(APIs.user.uid)
        .get()
        .then((value) {
      // print(value.data()!);
      self = User.fromJson(value.data()!);
      // print(self.toJson());
    });
  }

  // to create a new user

  static Future<void> createUser(String name) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final user = User(
        isUpdated: false,
        lastActive: currentTime,
        isOnline: true,
        id: APIs.user.uid,
        name: name,
        email: APIs.user.email!,
        imageUrl: "",
        phoneNumber: "",
        isPhoneHidden: true,
        createdAt: currentTime,
        state: "",
        address: "",
        gender: true,
        city: "",
        likes: ["hello"].toList());
    // final user = User(
    //     id: APIs.user.uid,
    //     name: name,
    //     email: APIs.user.email!,
    //     imageUrl: "",
    //     phoneNumber: "",
    //     isPhoneHidden: true,
    //     createdAt: currentTime);

    await APIs.firestore
        .collection("users")
        .doc(APIs.user.uid)
        .set(user.toJson());

    await getUserInfo();
  }

  // to get uploaded image url
  static Future<String> getImageURL(File file, String name) async {
    final ext = file.path.split('.').last;
    final ref =
        APIs.storage.ref().child('doctor_iamges/${APIs.user.uid}/$name.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Picture data : ${p0.bytesTransferred / 1000} kb');
    });

    final String url = await ref.getDownloadURL();

    return url;
  }

  // to update user profile
  static Future<void> updateUserProfile(User user) async {
    await APIs.firestore.collection("users").doc(APIs.user.uid).update({
      'name': user.name,

      'imageUrl': user.imageUrl,
      'phoneNumber': user.phoneNumber,
      'isUpdated': true,
      // New properties to JSON
      'state': user.state,
      'address': user.address,
      'gender': user.gender,
      'city': user.city
    });

    await getUserInfo();
  }

  // to get all doctors info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDoctorsInfo() {
    return APIs.firestore
        .collection('doctors')
        .where('isReviewed', isEqualTo: true)
        .where('isApproved', isEqualTo: true)
        .snapshots();
  }

  // to get all doctors info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPopularDoctorsInfo() {
    return APIs.firestore
        .collection('doctors')
        .where('isReviewed', isEqualTo: true)
        .where('isApproved', isEqualTo: true)
        .orderBy('favoritesCount', descending: true)
        .limit(20)
        .snapshots();
  }

  // to get specific type doctors info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSpecificDoctorsInfo(
      String speciality) {
    return APIs.firestore
        .collection('doctors')
        .where('speciality', isEqualTo: speciality)
        .snapshots();
  }

  // update active time
  static Future<void> updateActiveTime(bool isOnline) async {
    await APIs.firestore.collection('users').doc(APIs.user.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  // to add appointments
  static Future<void> addAppointment(
      Doctor doctor, String time, DateTime date) async {
    final appointment = Appointment(
        id: ChatApis.getConversationId(doctor.id),
        doctorId: doctor.id,
        patientId: APIs.user.uid,
        date: date,
        time: time,
        approved: false,
        statusUpdated: false);

    await APIs.firestore
        .collection('users')
        .doc(APIs.user.uid)
        .collection('appointments')
        .doc(ChatApis.getConversationId(doctor.id))
        .set({'id': ChatApis.getConversationId(doctor.id)});
    await APIs.firestore
        .collection('doctors')
        .doc(doctor.id)
        .collection('appointments')
        .doc(ChatApis.getConversationId(doctor.id))
        .set({'id': ChatApis.getConversationId(doctor.id)});

    await APIs.firestore
        .collection('appointments')
        .doc(ChatApis.getConversationId(doctor.id))
        .set(appointment.toJson());
  }

  // get appointments
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAppointments(
    List<String> ids,
  ) {
    return APIs.firestore
        .collection('appointments')
        .where('id', whereIn: ids.isEmpty ? [""] : ids)
        .snapshots();
  }

  // appointments ids getter
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAppointmentIdsInfo(
      String col, String id) {
    return APIs.firestore
        .collection(col)
        .doc(id)
        .collection('appointments')
        .snapshots();
  }

  // get appointment doctors
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getAllAppointmentDoctorsInfo(List<String> doctorIds) {
    return APIs.firestore
        .collection('doctors')
        .where('id', whereIn: doctorIds.isEmpty ? [""] : doctorIds)
        .snapshots();
  }

  // get appointment users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAppointmentUsersInfo(
      List<String> doctorIds) {
    return APIs.firestore
        .collection('users')
        .where('id', whereIn: doctorIds.isEmpty ? [""] : doctorIds)
        .snapshots();
  }

  // handle likes
  static Future<void> handleLike(Doctor doctor) async {
    if (self.likes.contains(doctor.id)) {
      DoctorApis.decrementLike(doctor);
      self.likes.remove(doctor.id);
      await APIs.firestore
          .collection('users')
          .doc(APIs.user.uid)
          .update({'likes': self.likes});
    } else {
      DoctorApis.incrementLike(doctor);
      self.likes.add(doctor.id);
      await APIs.firestore
          .collection('users')
          .doc(APIs.user.uid)
          .update({'likes': self.likes});
    }

    await getUserInfo();
  }
}
