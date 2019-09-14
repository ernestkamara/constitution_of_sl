import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const footer_text = "Sierra Leone\'s Constitution of 1996 with Amendments through 2008";

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
                child: Image.asset('assets/graphics/splash_logo.jpg'),
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
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, _navigationPage);
  }

  void _navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }
}
