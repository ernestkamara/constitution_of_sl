import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const footer_text = "The Constitution Of The Sierra Leone with Amendments through 2008";
  static const logoUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Coat_of_arms_of_Sierra_Leone.svg/600px-Coat_of_arms_of_Sierra_Leone.svg.png";

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            SizedBox(
              child:Image.network(logoUrl, fit: BoxFit.fitHeight,),
              height: 150,
              width: 150,
            ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AutoSizeText(
                    footer_text,
                    maxLines: 300,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ), ),
      ),
    );
  }

  _startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, _navigationPage);
  }

  void _navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }
}
