import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medical_hub/api/apis.dart';

import 'package:medical_hub/models/doctor.dart';

class DoctorApis {
  // for storing current doctor info

  static Doctor self = Doctor(
      lastActive: "",
      id: APIs.user.uid,
      registrationNumber: "registrationNumber",
      name: "Name",
      speciality: "speciality",
      profileImageUrl: "profileImageUrl",
      email: APIs.user.uid,
      favoritesCount: 0,
      isOnline: true,
      createdAt: "",
      phone: "phone",
      gender: true,
      state: "state",
      city: "",
      address: "address",
      cnicImageUrl: "cnicImageUrl",
      licenseImageUrl: "licenseImageUrl",
      qualification: "qualification",
      isUpdated: false,
      isReviewed: false,
      isApproved: false,
      availableDays: [],
      availableTime: []);

  // to create doctor profile at backend
  static Future<void> createDoctor(String name) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    final Doctor doctor = Doctor(
        availableDays: [""],
        availableTime: [""],
        id: APIs.user.uid,
        registrationNumber: "",
        name: name,
        speciality: "",
        profileImageUrl: "",
        email: APIs.user.email!,
        favoritesCount: 0,
        isOnline: false,
        createdAt: currentTime,
        lastActive: currentTime,
        phone: "",
        gender: true,
        state: "",
        city: "",
        address: "",
        cnicImageUrl: "",
        licenseImageUrl: "",
        qualification: "",
        isUpdated: false,
        isReviewed: false,
        isApproved: false);
    // final doctor = Doctor(
    //     id: APIs.user.uid,
    //     registrationNumber: "",
    //     name: name,
    //     specialty: "",
    //     : "",
    //     email: APIs.user.email!,
    //     favoritesCount: 0,
    //     // availableDays: [],
    //     // availableTimes: {"": []},
    //     isOnline: true,
    //     createdAt: currentTime);

    await APIs.firestore
        .collection("doctors")
        .doc(APIs.user.uid)
        .set(doctor.toJson());

    await getDoctorInfo();
  }

  // to update doctor profile

  static Future<void> updateDoctorProfile(Doctor doctor) async {
    await APIs.firestore.collection("doctors").doc(APIs.user.uid).update({
      "registrationNumber": doctor.registrationNumber,
      "name": doctor.name,
      'profileImageUrl': doctor.profileImageUrl,
      'speciality': doctor.speciality,
      // 'availableDays': availableDays,
      // 'availableTimes': availableTimes,
      'isUpdated': true,
      'isReviewed': false,
      'isApproved': false,
      'phone': doctor.phone,
      'gender': doctor.gender,
      'state': doctor.state,
      'city': doctor.city,
      'address': doctor.address,
      'cnicImageUrl': doctor.cnicImageUrl,
      'licenseImageUrl': doctor.licenseImageUrl,
      'qualification': doctor.qualification,
      'availableDays': doctor.availableDays,
      'availableTime': doctor.availableTime,
    });

    await getDoctorInfo();
  }

  // for getting current doctor info

  static Future<void> getDoctorInfo() async {
    await APIs.firestore
        .collection('doctors')
        .doc(APIs.user.uid)
        .get()
        .then((value) {
      // print(value.data()!);
      self = Doctor.fromJson(value.data()!);
      // print(self.toJson());
    });
  }

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

  static Future<void> updateActiveTime(bool isOnline) async {
    await APIs.firestore.collection('doctors').doc(APIs.user.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  static Future<void> addInboxUsers(Doctor doctor) async {
    bool isExist = (await APIs.firestore
            .collection('doctors')
            .doc(doctor.id)
            .collection('chatUsers')
            .doc(APIs.user.uid)
            .get())
        .exists;

    // print(isExist);

    if (isExist) {
      return;
    } else {
      await APIs.firestore
          .collection('doctors')
          .doc(doctor.id)
          .collection('chatUsers')
          .doc(APIs.user.uid)
          .set({'id': APIs.user.uid});

      // print('chatUserCreated successfully');
    }
  }

  static Future<void> updateAppointmentStatus(String id, bool approved) async {
    // print(id);
    await APIs.firestore
        .collection('appointments')
        .doc(id)
        .update({'statusUpdated': true, 'approved': approved});
  }

  // decrement likes
  static Future<void> decrementLike(Doctor doctor) async {
    await APIs.firestore
        .collection('doctors')
        .doc(doctor.id)
        .update({'favoritesCount': doctor.favoritesCount - 1});
  }

  static Future<void> incrementLike(Doctor doctor) async {
    await APIs.firestore
        .collection('doctors')
        .doc(doctor.id)
        .update({'favoritesCount': doctor.favoritesCount + 1});
  }

  // update profile pictures
//   static Future<void> updateDoctorProfile(Doctor doctor) async {
//     //getting extension of image

//     //updating image url in user data
//     self.image = await ref.getDownloadURL();

//     //updating on firestore database
//     await firestore
//         .collection('users')
//         .doc(user.uid)
//         .update({'image': self.image});
//   }
// }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSelfInfo() {
    return APIs.firestore.collection('doctors').doc(APIs.user.uid).snapshots();
  }
}
