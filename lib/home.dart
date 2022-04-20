// // ignore_for_file: deprecated_member_use

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   PickedFile? _image;
//   bool _loading = false;
//   List<dynamic>? _outputs;

//   void initState() {
//     super.initState();
//     _loading = true;

//     loadModel().then((value) {
//       setState(() {
//         _loading = false;
//       });
//     });
//   }

// //Load the Tflite model
//   loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/model_unquant.tflite",
//       labels: "assets/labels.txt",
//     );
//   }

//   classifyImage(image) async {
//     var output = await Tflite.runModelOnImage(
//       path: image.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );
//     setState(() {
//       _loading = false;
//       //Declare List _outputs in the class which will be used to show the classified classs name and confidence
//       _outputs = output;
//     });
//   }

//   Future pickImage() async {
//     var image = await _picker.getImage(source: ImageSource.gallery);
//     if (image == null) return null;
//     setState(() {
//       _loading = true;
//       _image = image;
//     });
//     classifyImage(image);
//   }

//   final ImagePicker _picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(20, 84, 10, 0.8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30),
//           ),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/logo.png',
//               fit: BoxFit.contain,
//               height: 45,
//             ),
//             Container(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Weed Detector',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                         color: Colors.white)))
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 20),
//             Center(
//               child: _loading
//                   ? Container()
//                   : Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _image == null
//                               ? Container()
//                               : Image.file(
//                                   File(_image!.path),
//                                 ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           _outputs != null
//                               ? Text(
//                                   '${_outputs![0]["label"]}',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20.0,
//                                     background: Paint()
//                                       ..color = Color.fromRGBO(20, 84, 10, 0.8),
//                                   ),
//                                 )
//                               : Container()
//                         ],
//                       ),
//                     ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: openGallery,
//                     child: Container(
//                       width: MediaQuery.of(context).size.width - 250,
//                       alignment: Alignment.center,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 25, vertical: 18),
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(20, 84, 10, 0.8),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         "Select a Photo",
//                         style: TextStyle(fontSize: 25, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //camera method
//   Future openGallery() async {
//     // ignore: deprecated_member_use
//     var piture = await _picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       _image = piture;
//       print(_image);
//     });
//     classifyImage(piture);
//   }
// }
