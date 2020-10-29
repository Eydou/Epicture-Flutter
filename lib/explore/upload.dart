import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';



Route transitionUpload(String token) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => UploadImage(token),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class UploadImage extends StatefulWidget {
  final String token;

  const UploadImage(this.token);
  createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String _textFromFile = "";

  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }
  @override
  void initState() {
    super.initState();
    isNull(_imageFile);
  }
  void _clear() {
    setState(() => _imageFile = null);
  }
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    myController2.dispose();
    myController.dispose();
    super.dispose();
  }
  Future<void> isNull(File image) async {
    if (image == null) {
      setState(() => _textFromFile = "Post Error");
    } else {
      setState(() => _textFromFile = "Post Success");
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Upload'),
        backgroundColor: Colors.lightBlue,
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF332F43),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera, size: 30, color: Colors.white),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library, size: 30, color: Colors.white),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        icon: Icon(Icons.add),
        label: Text('Share !'),
        onPressed: () {
          Alert(
              context: context,
              style: alertStyle,
              title: "Post",
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.title),
                      labelText: 'title',
                    ),
                  ),
                  TextField(
                    controller: myController2,
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: 'description',
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    send(_imageFile, myController.text, myController2.text, context);
                    isNull(_imageFile);
                    Navigator.pop(context);
                    Flushbar(
                      title: "File",
                      message: _textFromFile,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      reverseAnimationCurve: Curves.decelerate,
                      forwardAnimationCurve: Curves.elasticInOut,
                      showProgressIndicator: true,
                      duration: Duration(seconds: 3),
                    ).show(context);
                  } ,
                  child: Text(
                    "PUBLISH",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        },
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.refresh, size: 30, color: Colors.white),
                  onPressed: _clear,
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

    send(File image, String title, String desc,BuildContext context) async {
    String url = "https://api.imgur.com/3/upload/";
    var img = base64Encode(image.readAsBytesSync());
    var uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer ' + widget.token
      },
      body: {
        'image': img,
        'title': title ,
        'description': desc,
      },
    );

    final responseJson = json.decode(response.body);

    print(responseJson);
  }
}

var alertStyle = AlertStyle(
  animationType: AnimationType.fromTop,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  descTextAlign: TextAlign.start,
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0.0),
    side: BorderSide(
      color: Colors.grey,
    ),
  ),
);