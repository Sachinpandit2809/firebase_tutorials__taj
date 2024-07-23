import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/ui/screens/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(" Post "),
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => LoginScreen())));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(child: Text("POST")),
    );
  }
}
