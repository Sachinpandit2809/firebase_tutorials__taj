import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/utils/utils.dart';
import 'package:helloworld/widgets/my_drawer.dart';
import 'package:helloworld/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';

class NewUploadImage extends StatefulWidget {
  const NewUploadImage({super.key});

  @override
  State<NewUploadImage> createState() => _NewUploadImageState();
}

class _NewUploadImageState extends State<NewUploadImage> {
//   File? image;
//   final picker = ImagePicker();

//   Future<void> newGetgalleryImage() async {
//     final pickPhoto = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickPhoto != null) {
//         image = File(pickPhoto.path);
//       } else {
//         Utils().toastErrorMessage("no image picked");
//       }
//     });
//   }

// ////copied
//   ///

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         title: Text("imageUpload "),
//       ),
//       body: Column(
//         children: [
//           InkWell(
//             onTap: () {
//               newGetgalleryImage();
//             },
//             child: Container(
//               decoration:
//                   BoxDecoration(border: Border.all(color: Colors.black)),
//               height: 200,
//               width: 200,
//               child: image != null
//                   ? Image.file(image!.absolute)
//                   : Center(child: Icon(Icons.photo)),
//             ),
//           ),
//           RoundButton(title: "upload", ontap: (){

//           })
//         ],
//       ),
//     );
//   }
// }

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      _uploadImageToFirebase(image);
    }
  }

  Future<void> _uploadImageToFirebase(XFile image) async {
    try {
      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Save image URL to Firebase Database
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('images');
      await databaseRef.push().set({'url': downloadURL});

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Upload Image to Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(File(_image!.path))
                : Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
