
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:constitution_of_sl/src/screens/home_page.dart';
import 'package:constitution_of_sl/src/screens/splash.dart';
import 'package:flutter/material.dart';

void main() {
  try {
    initializeApp(
        apiKey: "AIzaSyBSHlyi1vblToBtdDd5Xa7SXUU_FZ3j1l8",
        authDomain: "const-sl.firebaseapp.com",
        databaseURL: "https://const-sl.firebaseio.com",
        storageBucket: "const-sl.appspot.com",
        projectId: "const-sl",
    );
    final app = App();
    runApp(app);
  } on FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

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

