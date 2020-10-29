import 'package:epicture/login.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';


final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_){
    runApp(MyApp());
  }
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EpicLopes',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFF332F43)),
      home: SplashS(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class SplashS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new LoginImgur(),
      title: Text(
        'EPICLOPES',
        style: new TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = linearGradient),
      ),
      image: Image.asset(
        'assets/icon.png',
      ),
      photoSize: 100.0,
      loaderColor: Colors.lightBlue,
      backgroundColor: Color(0xFF332F43),
    );
  }
}