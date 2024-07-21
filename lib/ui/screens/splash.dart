import "package:flutter/material.dart";
import "package:helloworld/firebase_services/splash_services.dart";

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 100,
            child: Center(child: Text("FireBase Splash"))),
      ),
    );
  }
}
