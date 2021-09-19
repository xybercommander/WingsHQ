import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/helper/history.dart';
import 'package:wings_hq/pages/authenticate_page.dart';
import 'package:wings_hq/pages/navigation_page.dart';

class SplashScreen extends StatefulWidget {
  //SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn=false;
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
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
    Timer(Duration(seconds: 3),(){
      History.pushPageReplacement(context,_isLoggedIn ? NavigationPage() : AuthenticatePage(),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('images/logo_screen.png'),
            ),
            SizedBox(height:20.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
            //Text('Welcome! 🎉',style: TextStyle(color: Colors.black,fontSize: 30,fontFamily: "SF Pro"),),
          ]
        ),
      ),

    );
  }
}