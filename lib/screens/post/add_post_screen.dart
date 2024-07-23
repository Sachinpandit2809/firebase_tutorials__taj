import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:helloworld/screens/post/post_screen.dart";
import "package:helloworld/utils/utils.dart";
import "package:helloworld/widgets/round_button.dart";

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController addPostController = TextEditingController();
  bool loading = false;
  final databaseref = FirebaseDatabase.instance.ref("post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Add post"),
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
                  databaseref.child(id).set({
                    "title": addPostController.text.toString(),
                    "id": id,
                  }).then((value) {
                    Utils().toastSuccessMessage("added");
                    setState(() {
                      loading = false;
                    });
                  }).onError(
                    (error, stackTrace) {
                      Utils().toastErrorMessage(error.toString());
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
