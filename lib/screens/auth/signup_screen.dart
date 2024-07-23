import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'login_screen.dart';
import 'package:helloworld/utils/utils.dart';

import 'package:helloworld/widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        // automaticallyImplyLeading: false,

        title: const Text("SignUp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "email",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: "password",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter password";
                        }
                        return null;
                      }),
                ],
              )),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
            title: "Signin",
            loading: isLoading,
            ontap: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });

                _auth
                    .createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString())
                    .then((onValue) {
                  setState(() {
                    isLoading = false;
                  });
                }).catchError((error, stackTrace) {
                  setState(() {
                    isLoading = false;
                  });
                  Utils().toastErrorMessage(error.toString());
                });
              }
            },
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("allready have account"),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text("Login"))
            ],
          )
        ],
      ),
    );
  }
}
