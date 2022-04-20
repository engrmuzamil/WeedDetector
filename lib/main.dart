import 'package:flutter/material.dart';
import 'package:weed_detector/SplashScreen.dart';

void main() {
  runApp(const Main());
}
class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Weed Detector",
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}

