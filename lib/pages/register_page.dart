import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hackmit/helper/helper_functions.dart';
import 'package:hackmit/pages/home_page.dart';
import 'package:hackmit/pages/navigation_page.dart';
import 'package:hackmit/services/auth_service.dart';
import 'package:hackmit/shared/constants.dart';
import 'package:hackmit/shared/loading.dart';


class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;  

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.registerWithEmailAndPassword(fullName, email, password).then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);

          print("Registered");
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
            error = 'Error while registering the user!';
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
              image: AssetImage('images/signup_final.png'),
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
                  color: Color(0xff000000),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
      child: Form(
        key: _formKey,
        child: Container(
          color: Color(0xff000000),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Create or Join Groups", style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily:"SF Pro")),
                    
                  SizedBox(height: 30.0),
                    
                  Text("Register", style: TextStyle(color: Colors.white, fontSize: 25.0,fontFamily:"SF Pro")),
                    
                  SizedBox(height: 20.0),
                    
                  TextFormField(
                    style: TextStyle(color: Colors.white,fontFamily:"SF Pro"  ),
                    decoration: textInputDecoration.copyWith(labelText: 'Full Name'),
                    onChanged: (val) {
                      setState(() {
                        fullName = val;
                      });
                    },
                  ),
                    
                  SizedBox(height: 15.0),
                    
                  TextFormField(
                    style: TextStyle(color: Colors.white,fontFamily:"SF Pro"),
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
                    style: TextStyle(color: Colors.white,fontFamily:"SF Pro"),
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
                      child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 20.0,fontFamily:"SF Pro")),
                      onPressed: () {
                        _onRegister();
                      }
                    ),
                  ),

                  SizedBox(height: 10.0),
                    
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 20.0,fontFamily:"SF Pro"),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(fontSize: 20.0,color: Colors.white, decoration: TextDecoration.underline,fontFamily:"SF Pro"),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),
                    
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0,fontFamily:"SF Pro")),
                ],
              ),
            ],
          ),
        )
      ),
        ),
            ],
          ),
        
              ),
       
          ),
              
    );
  }
}
