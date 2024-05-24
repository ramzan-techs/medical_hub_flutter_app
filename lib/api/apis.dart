import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medical_hub/api/doctor_apis.dart';
import 'package:medical_hub/api/user_apis.dart';
import 'package:medical_hub/models/base_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing current user
  static User get user => auth.currentUser!;

  // for accessing databse
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing storage of files
  static FirebaseStorage storage = FirebaseStorage.instance;

  // ************* Authentication APIs *************** //

  //creating new user with email and password
  static Future<UserCredential> createUser(
      String userEmail, String userPassword) async {
    try {
      final credential = await APIs.auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'email-already-in-use') {
        throw ('The email address is already in use.');
      } else if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'network-request-failed') {
        throw ('Check Internet Connection!');
      } else {
        throw ('FirebaseAuthException: ${e.code}');
      }
    } catch (e) {
      rethrow;
    }
  }

  //to send verification email'
  static Future<void> sendVerificationEmail() async {
    await user.sendEmailVerification();
  }

  //to login user with given credentials
  static Future<dynamic> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return {'userCredential': userCredential, 'error': null};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return {'userCredential': null, 'error': 'Invalid Credentials'};
      }
      return {'userCredential': null, 'error': 'Unknown error!'};
    } catch (e) {
      return {'userCredential': null, 'error': e.toString()};
    }
  }

// ************** Base User APIs ************** //

  static Future<void> createBaseUser(
    String name,
    UserType type,
  ) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    final baseUser = BaseUser(
        id: user.uid,
        name: name,
        userType: type,
        createdAt: currentTime,
        email: user.email!);

    await firestore
        .collection("base_users")
        .doc(user.uid)
        .set(baseUser.toJson());

    if (type == UserType.doctor) {
      log("Doctor Profile creating");
      await DoctorApis.createDoctor(name);
    } else {
      await UserApis.createUser(name);
    }
  }

  static Future<String> getUserType() async {
    final snapshot =
        await firestore.collection('base_users').doc(user.uid).get();
    final type = snapshot.data()!["user_type"];
    // print("User type ====== $type");
    return type.toString();
  }
}
