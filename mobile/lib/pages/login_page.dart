import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:test/controllers/auth-service.dart';
import 'package:test/controllers/chat.dart';
import 'package:test/controllers/db-service.dart';
import 'package:test/pages/home_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final dbService _service = dbService();
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  TextEditingController messageController = TextEditingController();
  List<String> messages = [];

  final IO.Socket socket = IO.io('http://10.0.2.2:3001', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
    });
    connectServer();
    receiveMessage();
    debugPrint('hello $user, from loginpage');
  }

  void connectServer() {
    socket.connect();
    socket.onConnect((_) {
      debugPrint('connected to server from login page');
    });
    socket.on('connect_error', (data) {
      debugPrint('Error connecting to server: $data');
    });
  }

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      socket.emit('chat_message', message);
      messageController.clear();
    }
  }

  void receiveMessage() {
    socket.on('response', (data) {
      setState(() {
        messages.add(data['dir']);
      });
      debugPrint(data['dir']);
    });
  }

  void gSignIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.handleGoogleSignIn();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
  }

  Widget googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: 'Sign up with Google',
          onPressed: gSignIn,
        ),
      ),
    );
  }

  Widget userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user!.photoURL!),
              ),
            ),
          ),
          Text(user!.email!),
          Text(user!.displayName ?? ""),
          MaterialButton(
            color: Colors.red,
            onPressed: signOut,
            child: const Text('Sign Out'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type message here',
                  ),
                ),
              ),
              IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auricurrus'),
      ),
      body: user != null ? userInfo() : googleSignInButton(),
    );
  }
}
