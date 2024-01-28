// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:test/controllers/db-service.dart';
// import 'package:test/models/user.dart';

// class AuthService extends ChangeNotifier {
//   Future<UserCredential> handleGoogleSignIn() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final FirebaseAuth auth = FirebaseAuth.instance;

//     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );

//     UserCredential authUser = await auth.signInWithCredential(credential);

//     String? displayName = authUser.user?.displayName;
//     String? email = authUser.user?.email;

//     var verified = await dbService().checkUser(email);
//     if (verified == true) {
//       print('user already registered');
//     } else {
//       dbUser user = dbUser(
//         name: displayName ?? 'null',
//         email: email ?? 'null',
//         hearingLossLevelLeft: 0,
//         hearingLossLevelRight: 0,
//         eventsHappened: 0,
//         mileage: 0,
//         tripTime: 0,
//         darkMode: false,
//         createdOn: Timestamp.now(),
//         updatedOn: Timestamp.now(),
//       );
//       dbService().addUser(user);
//       print('succesfully registered user');
//     }
//     return authUser;
//   }

//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//     await GoogleSignIn().signOut();
//   }
// }
