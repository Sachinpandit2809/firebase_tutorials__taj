import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/ui/screens/login_with_phone_number.dart';
import 'package:helloworld/ui/screens/post_screen.dart';
import 'package:helloworld/ui/screens/signup_screen.dart';
import 'package:helloworld/utils/utils.dart';

import 'package:helloworld/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
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
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Login"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
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
                          } else {
                            null;
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
                            } else {
                              null;
                            }
                            return null;
                          }),
                    ],
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Login",
              loading: loading,
              ontap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  _auth
                      .signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                      .then((onValue) {
                    Utils().toastSuccessMessage(
                        "Welcome :- ${onValue.user!.email}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostScreen()));
                    setState(() {
                      loading = false;
                    });
                  }).onError(
                    (error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastErrorMessage(error.toString());
                    },
                  );
                }
              },
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("dont't have account"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: const Text("SignUp")),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginWithPhoneNumber()));
                },
                child: Container(
                  margin: EdgeInsets.all(18),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.black)),
                  child: const Center(child: Text("login with phone")),
                ))
          ],
        ),
      ),
    );
  }
}
