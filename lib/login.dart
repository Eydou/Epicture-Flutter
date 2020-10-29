import 'package:epicture/home.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';

class LoginImgur extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginImgur();
  }
}

class _LoginImgur extends State<LoginImgur> {
  bool isLog = false;
  static String Id = "1f5103b97f1f1bd";
  String accessToken = "";
  String user = "";

  final url = "https://api.imgur.com/oauth2/authorize?client_id=" + Id + "&response_type=token";
  final LoginWVPlugins = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    if (isLog == true) {
      return Home(user, accessToken);
    } else
    return new WebviewScaffold(
      url: url,
    );
  }
  @override
  void initState() {
    super.initState();

    LoginWVPlugins.onUrlChanged.listen((String url) {
      if (url.contains("access_token=")) {
        Uri data = Uri.dataFromString(url.replaceFirst('#', '?'));
        setState(() {
          accessToken = data.queryParameters["access_token"];
          user = data.queryParameters["account_username"];
        });
        LoginWVPlugins.close();
        isLog = true;
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
}
