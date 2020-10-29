import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'upload.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class Explore extends StatefulWidget {
  final String token;

  const Explore(this.token);
  @override
  _Explore createState() => _Explore();
}

class _Explore extends State<Explore> {
  String searching;
  var fav = new List();

  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(1, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }

  Future <List> isSearch() async {
    String url = "https://api.imgur.com/3/gallery/search/" + searching;
    var client = http.Client();
    var picList = new List();

    await client
        .get(url, headers: {'Authorization': 'Client-ID ' + "1f5103b97f1f1bd"}).then((res) {
      var data = jsonDecode(res.body);
      print(picList);
      for (var j = 0; j < 14; j++) {
        for (var i in data["data"][j]["images"]) {
          if (i["type"] != "video/mp4") {
            picList.add(i["link"]);
          }
        }
      }
    });
    return picList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            loader: Text("loading..."),
            onSearch: search,
            onItemFound: (Post post, int index) {
              return lopes(context, post.title);
            },
          ),
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

  Widget lopes(BuildContext context, String title) {
    return Scaffold(
      body: ListView.builder(
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
        itemCount: fav.length,
      ),
    );
  }
}