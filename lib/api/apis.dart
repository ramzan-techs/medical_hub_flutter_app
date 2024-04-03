import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing current user
  static User get user => auth.currentUser!;

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

  //handle error
  // static String _handleError(dynamic e) {
  //   // You can handle different types of errors here and return appropriate error messages
  //   String errorMessage = "";
  //   // Example:
  //   if (e.code == 'user-not-found') {
  //     print('in no user found');
  //     errorMessage = 'No user found for that email.';
  //   } else if (e.code == 'wrong-password') {
  //     print('in wrong password');
  //     errorMessage = 'Wrong password provided for that user.';
  //   }
  //   return errorMessage;
  // }
}
