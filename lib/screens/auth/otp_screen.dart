import "dart:ffi";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "../post/post_screen.dart";
import "package:helloworld/utils/utils.dart";
import "package:helloworld/widgets/round_button.dart";

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("varify"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "+91 111 2222 333"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RoundButton(
              title: "varify",
              loading: loading,
              ontap: () async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text.toString());

                try {
                  await auth.signInWithCredential(credential);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  Utils().toastSuccessMessage(e.toString());
                }
              }),
        ],
      ),
    );
  }
}
