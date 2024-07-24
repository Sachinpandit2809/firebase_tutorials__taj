import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/screens/firestore/add_firestore_data.dart';
import 'package:helloworld/screens/post/add_post_screen.dart';
import 'package:helloworld/utils/utils.dart';
import '../auth/login_screen.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance;
  // final databaseRef = FirebaseDatabase.instance.ref("post");
  final fireStore = FirebaseFirestore.instance.collection("users").snapshots();
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();

  final deleteFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text(" FireStoreScreen "),
          titleTextStyle: TextStyle(color: Colors.white),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: searchFilterController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "search",
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text("error during communication");
                }

                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("${index + 1}" +
                                snapshot.data!.docs[index]['title']),
                          );
                        }));
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFirestoreData()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel")),
            TextButton(onPressed: () async {}, child: const Text("update"))
          ],
        );
      },
    );
  }
}

//   Image(
//       image: NetworkImage(
//           "https://images.pexels.com/photos/1758144/pexels-photo-1758144.jpeg?auto=compress&cs=tinysrgb&w=600")),
// Image(
//     image: NetworkImage(
//         "https://images.pexels.com/photos/1391498/pexels-photo-1391498.jpeg?auto=compress&cs=tinysrgb&w=600")),
