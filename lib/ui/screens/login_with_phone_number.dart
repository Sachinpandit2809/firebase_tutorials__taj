// import "dart:ffi";

// import "package:firebase_auth/firebase_auth.dart";
// import "package:flutter/material.dart";
// import "package:flutter/widgets.dart";
// import "package:helloworld/ui/screens/otp_screen.dart";
// import "package:helloworld/utils/utils.dart";
// import "package:helloworld/widgets/round_button.dart";

// class LoginWithPhoneNumber extends StatefulWidget {
//   const LoginWithPhoneNumber({super.key});

//   @override
//   State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
// }

// class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
//   bool loading = false;
//   final auth = FirebaseAuth.instance;
//   TextEditingController phoneNumberController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: TextFormField(
//               controller: phoneNumberController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(hintText: "+91 111 2222 333"),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           RoundButton(
//               title: "login",
//               loading: loading,
//               ontap: () {
//                 setState(() {
//                   loading = true;
//                 });
//                 auth.verifyPhoneNumber(verificationCompleted: (_) {
//                   setState(() {
//                     loading = false;
//                   });
//                 }, verificationFailed: (e) {
//                   Utils().toastErrorMessage(e.toString());
//                   setState(() {
//                     loading = false;
//                   });
//                 }, codeSent: (String varificationId, int? token) {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               OtpScreen(verificationId: varificationId)));
//                   setState(() {
//                     loading = false;
//                   });
//                 }, codeAutoRetrievalTimeout: (e) {
//                   Utils().toastErrorMessage(e.toString());
//                   setState(() {
//                     loading = false;
//                   });
//                 });
//               })
//         ],
//       ),
//     );
//   }
// }

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:helloworld/ui/screens/otp_screen.dart";
import "package:helloworld/utils/utils.dart";
import "package:helloworld/widgets/round_button.dart";

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "+91 111 2222 333"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RoundButton(
              title: "Login",
              loading: loading,
              ontap: () {
                setState(() {
                  loading = true;
                });

                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text, // Add this line
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    Utils().toastErrorMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationId, int? token) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OtpScreen(verificationId: verificationId)));
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e) {
                    Utils().toastErrorMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                );
              })
        ],
      ),
    );
  }
}
