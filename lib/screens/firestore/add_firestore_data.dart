import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helloworld/screens/firestore/firestore_screen.dart';
import 'package:helloworld/utils/utils.dart';
import "package:helloworld/widgets/round_button.dart";

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final TextEditingController addPostController = TextEditingController();
  bool loading = false;
  // final databaseref = FirebaseDatabase.instance.ref("post");
  final fireStore = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("AddDireStoreDAta"),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              maxLines: 4,
              controller: addPostController,
              decoration: InputDecoration(
                hintText: "what is in your mind ? ",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.purple)),
              ),
            ),
            const SizedBox(height: 10),
            RoundButton(
                title: "Post",
                loading: loading,
                ontap: () {
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().millisecondsSinceEpoch.toString();

                  fireStore.doc(id).set({
                    'title': addPostController.text.toString(),
                    'id': id,
                  }).then((onValue) {
                    Utils().toastSuccessMessage("added");
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirestoreScreen()));
                  }).onError(
                    (error, stackTrace) {
                      Utils().toastSuccessMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}



      // final id = DateTime.now().millisecondsSinceEpoch.toString();
                  // databaseref.child(id).set({
                  //   "title": addPostController.text.toString(),
                  //   "id": id,
                  // }).then((value) {
                  //   Utils().toastSuccessMessage("added");
                  //   setState(() {
                  //     loading = false;
                  //   });
                  // }).onError(
                  //   (error, stackTrace) {
                  //     Utils().toastErrorMessage(error.toString());
                  //     setState(() {
                  //       loading = false;
                  //     });
                  //   },
                  //  );