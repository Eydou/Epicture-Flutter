import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Favorite extends StatefulWidget {
  final String token;

  const Favorite(this.token);
  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  var fav = new List();
  var title = new List();

  @override
  void initState() {
    super.initState();
    isFav().then(
            (List s) => setState(() {fav = s;})
    );
    isTitle().then(
            (List s) => setState(() {title = s;})
    );
  }

  Future <List> isTitle() async {
    String url = "https://api.imgur.com/3/account/me/favorites/{{page}}/{{favoritesSort}}";
    var client = http.Client();
    var favoList = new List();

    await client
        .get(url, headers: {'Authorization': 'bearer ' + widget.token}).then((res) {
      var data = jsonDecode(res.body);
      for (var i in data["data"]) {
        favoList.add(i["title"]);
      }
      print(favoList);
    });
    return favoList;
  }

  Future <List> isFav() async {
    String url = "https://api.imgur.com/3/account/me/favorites/{{page}}/{{favoritesSort}}";
    var client = http.Client();
    var favoList = new List();

    await client
        .get(url, headers: {'Authorization': 'bearer ' + widget.token}).then((res) {
      var data = jsonDecode(res.body);
      for (var i in data["data"]) { favoList.add('https://i.imgur.com/' +
            i["cover"] + '.' +
            i["type"].toString().substring(6));
      }
    });
    return favoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: fav.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 20,
              color: Color(0xFF332F43),
              child: Column(
                children: <Widget>[
                  Image.network(fav[index]),
                  Text(
                    title[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  Icon(
                    Icons.favorite,
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
