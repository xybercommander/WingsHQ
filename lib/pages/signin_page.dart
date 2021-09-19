// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/pages/navigation_page.dart';
import 'package:wings_hq/services/auth_service.dart';
import 'package:wings_hq/services/database_service.dart';
import 'package:wings_hq/shared/constants.dart';
import 'package:wings_hq/shared/loading.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(email, password).then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.documents[0].data['fullName']
          );

          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavigationPage()));
        }
        else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Scaffold(

       body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_final.png'),
              fit: BoxFit.cover

            )
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(top: 28),  
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
      child: Form(
        key: _formKey,
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Create or Join Groups", style: TextStyle(color: Colors.white, fontSize: 25.0,fontFamily:"SF Pro")),
                
                  SizedBox(height: 30.0),
                
                  Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 25.0,fontFamily:"SF Pro")),

                  SizedBox(height: 20.0),
                
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: textInputDecoration.copyWith(labelText: 'Email'),
                    validator: (val) {
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
                    },
                  
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                
                  SizedBox(height: 15.0),
                
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: textInputDecoration.copyWith(labelText: 'Password'),
                    validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                
                  SizedBox(height: 20.0),
                
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(                      
                      elevation: 0.0,
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16.0,fontFamily:"SF Pro")),
                      onPressed: () {
                        _onSignIn();
                      }
                    ),
                  ),
                
                  SizedBox(height: 10.0),
                  
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ),
                
                  SizedBox(height: 20.0),

                  Text.rich(
                    TextSpan(
                      text: "Do you want to register as a Professional? ",
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => launch('https://forms.gle/vaPZFyGojp636arF7'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),
                
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 14,fontFamily:"SF Pro")),
                ],
              ),
            ],
          ),
        ),
      )
    ),
            ],
          ),
        ),
       ),
        );
  }
}
