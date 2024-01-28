import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/login_controller/login_controller.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign Out'),
          onPressed: () {
            ref.read(loginControllerProvider.notifier).signOut();
          },
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   // final dbService _service = dbService();

//   // User? user;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('hello from homepage');
//   }

//   void signOut() async {
//     try {
//       final authService = Provider.of<AuthService>(context, listen: false);
//       await authService.signOut();
//       debugPrint('logged out');
//     } catch (e) {
//       debugPrint('Sign out failed: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome to Auricurrus'),
//         actions: [
//           IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
//         ],
//       ),
//       // body: userInfo(),
//     );
//   }

//   // Widget userInfo() {
//   //   return SizedBox(
//   //     width: MediaQuery.of(context).size.width,
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       crossAxisAlignment: CrossAxisAlignment.center,
//   //       mainAxisSize: MainAxisSize.max,
//   //       children: [
//   //         Container(
//   //           height: 100,
//   //           width: 100,
//   //           decoration: BoxDecoration(
//   //             image: DecorationImage(
//   //               image: NetworkImage(user!.photoURL!),
//   //             ),
//   //           ),
//   //         ),
//   //         Text(user!.email!),
//   //         Text(user!.displayName ?? ""),
//   //         MaterialButton(
//   //           color: Colors.red,
//   //           onPressed: () async {
//   //             signOut();
//   //             Navigator.pushReplacement(
//   //               context,
//   //               MaterialPageRoute(builder: (context) => LoginPage()),
//   //             );
//   //           },
//   //           child: const Text('Sign Out'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget userInfo() {
//   //   return SizedBox(
//   //     width: MediaQuery.of(context).size.width,
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       crossAxisAlignment: CrossAxisAlignment.center,
//   //       mainAxisSize: MainAxisSize.max,
//   //       children: [
//   //         Container(
//   //           height: 100,
//   //           width: 100,
//   //           decoration: BoxDecoration(
//   //               // image: DecorationImage(
//   //               //   image: NetworkImage(user!.photoURL!),
//   //               // ),
//   //               ),
//   //         ),
//   //         // Text(user!.email!),
//   //         // Text(user!.displayName ?? ""),
//   //         MaterialButton(
//   //           color: Colors.red,
//   //           onPressed: () async {
//   //             await _service.signOut();
//   //             auth.authStateChanges().listen((event) {
//   //               if (event == null) {
//   //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//   //                   builder: (context) => LoginPage(),
//   //                 ));
//   //               }
//   //             });
//   //           },
//   //           child: const Text('Sign Out'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }
