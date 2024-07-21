import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/ui/screens/signup_screen.dart';

import 'package:helloworld/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                )),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Login",
              ontap: () {
                if (_formKey.currentState!.validate()) {}
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
                    child: const Text("SignUp"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
