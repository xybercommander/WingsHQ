// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hackmit/helper/helper_functions.dart';
import 'package:hackmit/pages/authenticate_page.dart';
import 'package:hackmit/pages/home_page.dart';
import 'package:hackmit/pages/splashscreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WingsHQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro',
        primarySwatch: Colors.purple
      ),
      home: SplashScreen(),
    );
  }
}

