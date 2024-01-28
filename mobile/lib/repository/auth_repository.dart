import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/controllers/db-service.dart';
import 'package:test/models/user.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;
  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential authUser = await _auth.signInWithCredential(credential);

      String? displayName = authUser.user?.displayName;
      String? email = authUser.user?.email;

      var verified = await dbService().checkUser(email);
      if (verified == true) {
        debugPrint('user already registered');
      } else {
        dbUser user = dbUser(
          name: displayName ?? 'null',
          email: email ?? 'null',
          hearingLossLevelLeft: 0,
          hearingLossLevelRight: 0,
          eventsHappened: 0,
          mileage: 0,
          tripTime: 0,
          darkMode: false,
          createdOn: Timestamp.now(),
          updatedOn: Timestamp.now(),
        );
        dbService().addUser(user);
        debugPrint('succesfully registered user');
      }

      return authUser.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-registered') {
        throw AuthException('user not found from google sign in');
      } else {
        throw AuthException('an error occured from google sign in');
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
