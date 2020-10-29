import 'dart:io';
import 'package:epicture/explore/upload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  final String name;
  final String token;

  const Profile(this.name, this.token);
  @override
  _Profile createState() => _Profile(name, token);
}

class _Profile extends State<Profile> {
  _Profile(this.user, this.token);

  final String user;
  final String token;
  var pictures = new List();
  var title = new List();

  @override
  void initState() {
    super.initState();
    sleep(Duration(milliseconds: 100));
    isProfile().then(
            (List s) => setState(() {pictures = s;})
    );
    isTitle().then(
            (List s) => setState(() {title = s;})
    );
  }

  Future <List> isTitle() async {
    const url = 'https://api.imgur.com/3/account/me/images';
    var client = new http.Client();
    var pictures = new List();

    await client.get(url, headers: {'Authorization': 'Bearer ' + widget.token}).then((res) {
      print(res.body);
      var data = jsonDecode(res.body);
      for (var i in data["data"]) {
        if (i["title"] != null)
          pictures.add(i["title"]);
        else
          pictures.add("no title");
        print(i["link"]);
      }
    });
    return pictures;
  }

  Future <List> isProfile() async {
    const url = 'https://api.imgur.com/3/account/me/images';
    var client = new http.Client();
    var pictures = new List();

    await client.get(url, headers: {'Authorization': 'Bearer ' + widget.token}).then((res) {
      print(res.body);
      var data = jsonDecode(res.body);
      for (var i in data["data"]) {
        pictures.add(i["link"]);
        print(i["link"]);
      }
    });
    return pictures;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.toString())),
      body: pictures.length != 0 ? ListView.builder(
        itemCount: pictures.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 20,
              color: Color(0xFF332F43),
              child: Column(
                children: <Widget>[
                  Image.network(pictures[index]),
                  Text(
                    title[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  Icon(
                    Icons.person,
                    color: Colors.lightBlue,
                    size: 40,
                  ),
                ],
              ),
            ),
          );
        },
      ) : Center(child: Text(
        "0 picture or gif uploaded",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () async {
      Navigator.of(context).push(transitionUpload(widget.token));
    },
    child: Icon(Icons.add),
    backgroundColor: Colors.deepPurple,
    ),
    );
  }
}
