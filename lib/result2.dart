import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  Category? _classifiedResult;
  var logger = Logger();
  late Classifier _classifier;

  int id = 1;
  @override
  void initState() {
    super.initState();
    // loadImageModel();
    _classifier = ClassifierQuant();
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
                      height: 300,
                      width: 300,
                    )
                  : Image.asset(
                      "assets/example.png",
                      height: 300,
                      width: 300,
                    ),
            ),
            SingleChildScrollView(
                child: Column(children: <Widget>[
              _classifiedResult != null
                  ? Container(
                      color: Color.fromRGBO(20, 84, 10, 0.8),
                      width: 300,
                      margin: EdgeInsets.all(10),
                      child: 10 == 10 //(_classifiedResult!.score * 100) >= 10
                          ? Center(
                              child: Text(
                                "Label:${_classifiedResult!.label}\nConfidence:  ${(_classifiedResult!.score * 10000).toStringAsFixed(1)}\nTime Taken: ${run.toString()}ms",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Center(
                              child: Text(
                                "Unknown Class",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    )
                  : Container()
            ])),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 500),
              child: Center(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        width: 200,
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
                              width: 200,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future loadImageModel() async {
  //   Tflite.close();
  //   var result;
  //   result = await Tflite.loadModel(
  //     model: "assets/model.tflite",
  //     labels: "assets/labels.txt",
  //   );
  //   print(result);
  // }
  PlatformFile? file2;
  Future selectImage() async {
    //final picker = ImagePicker();
    // var image =await picker.getImage(source: ImageSource.gallery, maxHeight: 300);

// show a dialog to open a file
    // FilePickerCross myFile = await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    //print(myFile.fileName);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'png', 'gif'],
        allowMultiple: false);
    print(result?.files.first.bytes.toString());

    setState(() {
      if (result != null) {
        //final  classifyImage(result.files.first);
        file2 = result.files.first;
        setimage(file2!);
        id = 2;
      } else {
        print('No image selected.');
      }
    });
  }

  void setimage(PlatformFile file) {
    File? _image = File(file.path.toString());
    _imageFile = File(file.path.toString());
  }

  var run;
  Future ci() async {
    if (id >= 2) {
      final runs = DateTime.now().millisecondsSinceEpoch;
      classifyImage(file2!);
      run = DateTime.now().millisecondsSinceEpoch - runs;
    }
  }

  Future classifyImage(PlatformFile file) async {
    _classifiedResult = null;
    File? _image = File(file.path.toString());
    //img.Image imageInput = img.decodeImage(_image.readAsBytesSync())!;

    final imageInput = img.decodeImage(_image.readAsBytesSync())!;

    print(imageInput.toString());
    // Run tensorflowlite image classification model on the image
    print("classification start $file");

    var pred = _classifier.predict(imageInput);
    // final List? result = await Tflite.runModelOnImage(
    //   path: file.path.toString(),
    //   numResults: 6,
    //   threshold: 0.05,
    //   imageMean: 127.5,
    //   imageStd: 127.5,
    // );

    print(pred.label + pred.score.toString());
    print("classification done");
    setState(() {
      if (file != null) {
        _imageFile = File(file.path.toString());
        id = 2;

        this._classifiedResult = pred;
      } else {
        print('No image selected.');
      }
    });
  }
}
