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
  final ref = FirebaseFirestore.instance.collection('users');

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
                  // ignore: use_build_context_synchronously
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
                            // ignore: prefer_interpolation_to_compose_strings
                            title: Text("${index + 1}" +
                                snapshot.data!.docs[index]['title']),
                            subtitle: Text(snapshot.data!.docs[index]['id']),
                            trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      child: const Text("update"),
                                      onTap: () {
                                        // Navigator.pop(context);
                                        showMyDialog(
                                            snapshot.data!.docs[index]['title'],
                                            snapshot.data!.docs[index]['id']);
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Text("delete"),
                                      onTap: () {
                                        {
                                          dynamic id =
                                              snapshot.data!.docs[index]['id'];
                                          ref.doc(id).delete().then((onValue) {
                                            Utils()
                                                .toastSuccessMessage("deleted");
                                            // Navigator.pop(context);
                                          }).onError(
                                            (error, stackTrace) {
                                              Utils().toastErrorMessage(
                                                  error.toString());
                                              Navigator.pop(context);
                                            },
                                          );
                                        }
                                      },
                                    )
                                  ];
                                }),
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
            TextButton(
                onPressed: () async {
                  ref
                      .doc(id)
                      .update({'title': editController.text.toString()}).then(
                          (onValue) {
                    Utils().toastSuccessMessage("updated");
                    Navigator.pop(context);
                  }).onError(
                    (error, stackTrace) {
                      Utils().toastErrorMessage(error.toString());
                      Navigator.pop(context);
                    },
                  );
                },
                child: const Text("update"))
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
