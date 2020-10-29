import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Feed extends StatefulWidget {
  final String token;

  const Feed(this.token);
  @override
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> {
  var pic = new List();
  var title = new List();

  @override
  void initState() {
    super.initState();
    sleep(Duration(milliseconds: 100));
    isFeed().then(
            (List s) => setState(() {pic = s;})
    );
  }

  Future <List> isFeed() async {
    String url = "https://api.imgur.com/3/gallery/hot/day";
    var client = http.Client();
    var picList = new List();

    await client
        .get(url, headers: {'Authorization': 'Client-ID ' + "1f5103b97f1f1bd"}).then((res) {
      var data = jsonDecode(res.body);
      print(data["data"][0]["images"]);
      for (var j = 0; j < 55; j++) {
        print(j);
        if (data["data"][j]["images"] != null)
        for (var i in data["data"][j]["images"]) {
          if (data["data"][j]["type"] != "video/mp4")
            picList.add(i["link"]);
            print(i["link"]);
        }
      }
    });
    print(picList);
    for (var d = 0; d < picList.length; d++) {
      if (picList[d].substring(picList[d].length - 1) == '4')
        picList.removeAt(d);
      print(picList[d].substring(picList[d].length - 1));
    }
    print(picList);
    return picList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: pic.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 20,
              color: Color(0xFF332F43),
              child: Column(
                children: <Widget>[
                  Image.network(pic[index]),
                  SizedBox(height: 10,),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.lightBlue,
                    size: 40,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
