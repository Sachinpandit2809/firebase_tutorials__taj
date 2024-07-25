import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/screens/firestore/firestore_screen.dart';
import 'package:helloworld/screens/post/post_screen.dart';
import 'package:helloworld/screens/upload_image/new_upload_image.dart';
import 'package:helloworld/utils/utils.dart';
import 'package:helloworld/widgets/my_drawer.dart';
import 'package:helloworld/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref().child("imagePost");
  // final databaseRef = FirebaseDatabase.instance.ref("users");

  Future getGalleryImage() async {
    final pickImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {
        debugPrint("no image selected");
        Utils().toastErrorMessage("no image selected");
      }
    });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Upload Image "),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              getGalleryImage();
              debugPrint("trigreed");
            },
            child: Center(
              child: Container(
                height: 400,
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: _image != null
                    ? Image.file(
                        _image!.absolute,
                        fit: BoxFit.cover,
                      )
                    : Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          RoundButton(
            title: 'Upload',
            loading: loading,
            ontap: () async {
              setState(() {
                loading = true;
              });
              //storage.ref('/sachin/${DateTime.now().millisecondsSinceEpoch}');
              try {
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref()
                    .child('/sachin${DateTime.now().millisecondsSinceEpoch}');

                firebase_storage.UploadTask uploadTask =
                    // ref.putFile(_image!.absolute);

                    ref.putFile(File(_image!.path));

                Future.value(uploadTask).then((onValue) async {
                  var imageLink = await ref.getDownloadURL();

                  databaseRef.child("1").set({
                    'title': imageLink.toString(),
                    'id': "1",
                  }).then((onValue) {
                    setState(() {
                      loading = false;
                      Utils().toastSuccessMessage("uploaded");
                    });
                  }).onError((e, s) {
                    loading = false;
                    Utils().toastErrorMessage("1st " + e.toString());
                  });
                }).onError((e, s) {
                  loading = false;
                  Utils().toastErrorMessage("2nd" + e.toString());
                });
              } catch (e) {
                setState(() {
                  loading = false;
                  Utils().toastErrorMessage("please select image ");
                });
              }
            },
          )
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UploadImage extends StatefulWidget {
//   @override
//   _UploadImageState createState() => _UploadImageState();
// }

// class _UploadImageState extends State<UploadImage> {
//   File? _image;
//   final picker = ImagePicker();

//   Future pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImage() async {
//     if (_image == null) return;

//     final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     final destination = 'files/$fileName';

//     try {
//       final ref = FirebaseStorage.instance.ref(destination);
//       await ref.putFile(_image!);
//       final downloadUrl = await ref.getDownloadURL();

//       await FirebaseFirestore.instance.collection('uploads').add({
//         'url': downloadUrl,
//         'uploaded_at': Timestamp.now(),
//       });

//       print('Upload complete');
//     } catch (e) {
//       print('error occurred');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Image to Firebase'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null ? Text('No image selected.') : Image.file(_image!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: Text('Pick Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: uploadImage,
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
