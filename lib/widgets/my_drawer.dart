import 'package:flutter/material.dart';
import 'package:helloworld/screens/firestore/firestore_screen.dart';
import 'package:helloworld/screens/post/post_screen.dart';
import 'package:helloworld/screens/upload_image/new_upload_image.dart';
import 'package:helloworld/screens/upload_image/upload_image.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.green,
      child: ListView(
        children: [
          ListTile(
            title: Text("firebase DataBase"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostScreen()));
            },
          ),
          ListTile(
            title: Text("firebase Firestore"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FirestoreScreen()));
            },
          ),
          ListTile(
            title: Text("Upload image"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadImage()));
            },
          ),
          ListTile(
            title: Text("Upload image chatGpt"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewUploadImage()));
            },
          ),
        ],
      ),
    );
  }
}
