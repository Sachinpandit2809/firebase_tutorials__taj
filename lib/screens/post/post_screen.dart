import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/screens/post/add_post_screen.dart';
import 'package:helloworld/utils/utils.dart';
import '../auth/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref("post");
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();

  final deleteFilterController = TextEditingController();

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
          // Expanded(
          //     child: StreamBuilder(
          //         stream: databaseRef.onValue,
          //         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot)  {
          //           if (!snapshot.hasData) {
          //             return const Center(child: CircularProgressIndicator());
          //           } else  {
          //             Map<dynamic, dynamic> map =
          //                 snapshot.data!.snapshot.value as dynamic;
          //             List<dynamic> list = [];
          //             list.clear();
          //             list = map.values.toList();
          //             return ListView.builder(
          //                 itemCount: snapshot.data!.snapshot.children.length,
          //                 itemBuilder: (context, index) {
          //                   return ListTile(
          //                     title: Text(list[index]['title']),
          //                   );
          //                 });
          //           }
          //         })),

          Expanded(
              child: FirebaseAnimatedList(
                  query: databaseRef,
                  defaultChild:
                      const Center(child: CircularProgressIndicator()),
                  itemBuilder: (
                    context,
                    snapshot,
                    animation,
                    index,
                  ) {
                    final title = snapshot.child("title").value.toString();

                    final id = snapshot.child("id").value.toString();
                    if (searchFilterController.text.isEmpty) {
                      return ListTile(
                        title: Text("${index + 1}) "
                            " ${snapshot.child('title').value}"),
                        subtitle: Text("${index + 1}) "
                            " ${snapshot.child('id').value}"),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              title: const Text("edit"),
                              trailing: const Icon(Icons.edit),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(title, id);
                              },
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              title: const Text("delete"),
                              trailing: const Icon(Icons.edit),
                              onTap: () async {
                                databaseRef.child(id).remove();
                                Navigator.pop(context);
                                // await databaseRef
                                //     .child(id)
                                //     .remove()
                                //     .then((onValue) {
                                //   Utils().toastSuccessMessage("deleted");
                                //   Navigator.pop(context);
                                // }).onError(
                                //   (error, stackTrace) {
                                //     Utils().toastErrorMessage(error.toString());
                                //     Navigator.pop(context);
                                //   },
                                // );
                              },
                            )),
                          ],
                        ),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchFilterController.text.toLowerCase())) {
                      return ListTile(
                        title: Text("${index + 1}) "
                            " ${snapshot.child('title').value}"),
                        subtitle: Text("${index + 1}) "
                            " ${snapshot.child('id').value}"),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              title: const Text("edit"),
                              trailing: const Icon(Icons.edit),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(title, id);
                              },
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              title: const Text("delete"),
                              trailing: const Icon(Icons.edit),
                              onTap: () async {
                                databaseRef.child(id).remove();
                                Navigator.pop(context);
                                // await databaseRef
                                //     .child(id)
                                //     .remove()
                                //     .then((onValue) {
                                //   Utils().toastSuccessMessage("deleted");
                                //   Navigator.pop(context);
                                // }).onError(
                                //   (error, stackTrace) {
                                //     Utils().toastErrorMessage(error.toString());
                                //     Navigator.pop(context);
                                //   },
                                // );
                              },
                            )),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: const Icon(Icons.add),
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
                  await databaseRef.child(id).update({
                    "title": editController.text.toString(),
                  }).then((onValue) {
                    Utils().toastSuccessMessage("Updated");
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
