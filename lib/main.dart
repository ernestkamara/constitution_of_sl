
import 'package:flutter/material.dart';

import 'package:constitution_of_sl/src/screens/home_page.dart';
import 'package:constitution_of_sl/src/screens/splash.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static const title = "Sierra Leone Constitution";
  static const home_page_title = "Constitution of the Republic of Sierra Leone";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => HomePage(title: home_page_title)
      },
    );
  }
}

