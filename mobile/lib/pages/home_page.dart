import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/controllers/auth-service.dart';
import 'package:test/controllers/db-service.dart';
import 'package:test/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // final dbService _service = dbService();

  // User? user;

  @override
  void initState() {
    super.initState();
    // auth.authStateChanges().listen((event) {
    //   setState(() {
    //     user = event;
    //   });
    // });
    debugPrint('hello from homepage');
  }

  void signOut() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();
      debugPrint('logged out');
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Auricurrus'),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      // body: userInfo(),
    );
  }

  // Widget userInfo() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Container(
  //           height: 100,
  //           width: 100,
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: NetworkImage(user!.photoURL!),
  //             ),
  //           ),
  //         ),
  //         Text(user!.email!),
  //         Text(user!.displayName ?? ""),
  //         MaterialButton(
  //           color: Colors.red,
  //           onPressed: () async {
  //             signOut();
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => LoginPage()),
  //             );
  //           },
  //           child: const Text('Sign Out'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget userInfo() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Container(
  //           height: 100,
  //           width: 100,
  //           decoration: BoxDecoration(
  //               // image: DecorationImage(
  //               //   image: NetworkImage(user!.photoURL!),
  //               // ),
  //               ),
  //         ),
  //         // Text(user!.email!),
  //         // Text(user!.displayName ?? ""),
  //         MaterialButton(
  //           color: Colors.red,
  //           onPressed: () async {
  //             await _service.signOut();
  //             auth.authStateChanges().listen((event) {
  //               if (event == null) {
  //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                   builder: (context) => LoginPage(),
  //                 ));
  //               }
  //             });
  //           },
  //           child: const Text('Sign Out'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
