import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:weed_detector/classifier.dart';
import 'package:weed_detector/classifier_quant.dart';
import 'package:image/image.dart' as img;

/*
  Notes:
  flutter channel master
  flutter upgrade
  flutter doctor
  set ENABLE_FLUTTER_DESKTOP=true
*/
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  List? _classifiedResult;
  // var logger = Logger();
  // late Classifier _classifier;

  int id = 1;
  @override
  void initState() {
    super.initState();
    loadImageModel();
    // _classifier = ClassifierQuant();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(20, 84, 10, 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 45,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('Weed Detector',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white)))
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: (_imageFile != null)
                  ? Image.file(
                      File(_imageFile!.path),
                    )
                  : Image.asset(
                      "assets/example.png",
                    ),
            ),
            Container(
                child: Row(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: _classifiedResult != null
                        ? _classifiedResult!.map((result) {
                            if ((result["confidence"] * 100) < 96) {
                              if (id == 10) id = 11;
                              if (id == 2) id = 10;
                            }
                            return Card(
                              elevation: 0.0,
                              color: Color.fromRGBO(20, 84, 10, 0.8),
                              child: id >= 10
                                  ? Container(
                                      child: id == 10
                                          ? Container(
                                              width: 300,
                                              margin: EdgeInsets.all(10),
                                              child: Center(
                                                child: id == 10
                                                    ? Text(
                                                        "Unknown Class",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Center(),
                                              ),
                                            )
                                          : Container())
                                  : Container(
                                      width: 300,
                                      margin: EdgeInsets.all(10),
                                      child: (result["confidence"] * 100) >= 96
                                          ? Center(
                                              child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Label: ${result["label"]} \nConfidence: ${result["confidence"].toStringAsFixed(2)}\nTime Taken: ${arr[index2++].toString()}ms",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  //                   ),
                                                ),
                                              ],
                                            ))
                                          : Center(),
                                    ),
                            );
                          }).toList()
                        : [],
                  ),
                ),
              ],
            )),

            // RaisedButton(
            //   onPressed: () {
            //     selectImage();
            //   },
            //   child: Text(
            //     "Choose Image",
            //     style: TextStyle(fontSize: 16, color: Colors.white),
            //   ),
            // ),

            //
            SizedBox(height: 20),
            Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: selectImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 210,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(20, 84, 10, 0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Choose Image",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20, width: 20),
                  id >= 2
                      ? GestureDetector(
                          onTap: ci,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 180,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(20, 84, 10, 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "Classify Image",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Center(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future loadImageModel() async {
    Tflite.close();
    var result;
    result = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
    print(result);
  }

  var run;
  var arr = [0, 0, 0, 0, 0, 0];
  var val;
  var index2;
  Future selectImage() async {
    final picker = ImagePicker();
    var image =
        // ignore: deprecated_member_use
        await picker.getImage(source: ImageSource.gallery, maxHeight: 300);

    val = 5;
    if (id != 2) id = 2;

    for (int i = 0; i <= 5; i++) arr[i] = 0;

    index = 0;
    index2 = 0;
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        id = 2;
        print("Here");
      } else {
        print('No image selected.');
      }
    });
  }

  int index = 0;
  Future ci() async {
    if (id >= 2) {
      final runs = DateTime.now().millisecondsSinceEpoch;
      classifyImage(_imageFile);
      run = DateTime.now().millisecondsSinceEpoch - runs;
      arr[index++] = run;
    }
  }

  Future classifyImage(image) async {
    _classifiedResult = null;
    // Run tensorflowlite image classification model on the image
    print("classification start $image");

    final List? result = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(result.toString());
    print("classification done");

    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        id = 2;
        print("Here");

        this._classifiedResult = result;
      } else {
        print('No image selected.');
      }
    });
  }
}
