import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:weed_detector/home.dart';
import 'package:weed_detector/result2.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: HomePage(),
      title: Text(
        "Weed Detector",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
      ),
      image: Image.asset('assets/logo.png'),
      backgroundColor: Color.fromRGBO(20, 84, 10, 0.8),
      photoSize: 90,
      loaderColor: Colors.white,
    );
  }
}
