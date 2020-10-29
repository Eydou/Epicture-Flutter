import 'package:epicture/favorite.dart';
import 'package:epicture/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:epicture/explore/explore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:imgur/imgur.dart';
import 'package:epicture/profile.dart';


class Home extends StatefulWidget {
  final _name;
  final _token;

  const Home(this._name, this._token);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int idx = 0;

  Widget getPage(int index) {
    if (index == 0) {
      return Feed(widget._token);
    }
    if (index == 1) {
      return Explore(widget._token);
    }
    if (index == 2) {
      return Favorite(widget._token);
    }
    if (index == 3) {
      return Profile(widget._name, widget._token);
    }
    return Profile( widget._name, widget._token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(idx),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.lightBlue,
        buttonBackgroundColor: Colors.lightBlue,
        height: 60,
        animationDuration: Duration(
          milliseconds: 200,
        ),
        index: idx,
        animationCurve: Curves.bounceInOut,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            idx = index;
          });
        },
      ),
    );
  }
}