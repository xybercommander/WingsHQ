import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackmit/helper/helper_functions.dart';
import 'package:hackmit/pages/authenticate_page.dart';
import 'package:hackmit/pages/bmi_calculator.dart';
import 'package:hackmit/pages/groups_page.dart';
import 'package:hackmit/pages/home_page.dart';
import 'package:hackmit/pages/private_chat/chatroom_list.dart';
import 'package:hackmit/pages/professionals_page.dart';
import 'package:hackmit/pages/profile_page.dart';
import 'package:hackmit/pages/search_page.dart';
import 'package:hackmit/pages/timer_main.dart';
import 'package:hackmit/services/auth_service.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({ Key key }) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {


  PageController pageController = PageController(initialPage: 0);
  List<Widget> pages = [HomePage(), GroupsPage(), ProfessionalsPage()];
  int _selectedIndex = 0;

  String _userName = '';
  String _email = '';
  FirebaseUser _user;
  final AuthService _auth = AuthService();

  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });    
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }


  Widget appBarTitle() {
    if(_selectedIndex == 0) {
      return Text('Your Timeline',style: TextStyle(color: Colors.black, fontSize: 24.0, fontFamily: "SF Pro"));
    } else if(_selectedIndex == 1) {
      return Text('Groups', style: TextStyle(color: Colors.black, fontSize: 27.0));
    } else if(_selectedIndex == 2) {
      return Text('Professionals', style: TextStyle(color: Colors.black, fontSize: 27.0, ));
    }
    // else  return Text('BMI', style: TextStyle(color: Colors.black, fontSize: 27.0, ));
  }




  @override
  void initState() {    
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        title: appBarTitle(),
        elevation: 0,
        backgroundColor: Color(0xfffcf9f3),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          _selectedIndex == 1
          ? IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Colors.black, size: 25.0), 
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
              }
            )
          : Container(),          
          
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.chat, color: Colors.black, size: 25.0), 
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivateChatRoomList()));
              }
            )
        ],       
      ),
      drawer: Drawer(        
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(_userName, textAlign: TextAlign.center, style: TextStyle(fontSize:24 ,fontFamily:"SF Pro")),
            SizedBox(height: 7.0),
            // ListTile(
            //   onTap: () {},
            //   selected: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            //   leading: Icon(Icons.group),
            //   title: Text('Groups'),
            // ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userName: _userName, email: _email)));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.explore),
              title: Text('Explore'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupsPage()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.people),
              title: Text('Groups'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.search),
              title: Text('Search'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BmiCalculator()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.calculate_rounded),
              title: Text('Calculate BMI'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimerApp()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.timer),
              title: Text('Timer'),
            ),
            Divider(
            color: Colors.grey[250],
            ),
            ListTile(
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),

      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        scrollDirection: Axis.horizontal,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xfffcf9f3),
         onTap: (value) {
          setState(() {
            _selectedIndex = value;
            pageController.animateToPage(_selectedIndex,
                duration: Duration(milliseconds: 300),
                curve: Curves.linearToEaseOut);
          });
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            // icon: Icon(Icons.home_rounded,
            //     color: _selectedIndex == 0
            //         ? Colors.purple[400]
            //         : Colors.grey[400]),
            icon: Image.asset(
              'images/home_icon.png',
              color: _selectedIndex == 0
                  ? Colors.black
                  : Colors.grey[400],
              width: 20,
              height: 20,
            ),
            // ignore: deprecated_member_use
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group,
                color: _selectedIndex == 1
                    ? Colors.black
                    : Colors.grey[400]),
            // ignore: deprecated_member_use
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/doctor.png',
              color: _selectedIndex == 2
                  ? Colors.black
                  : Colors.grey[500],
              width: 20,
              height: 20,
            ),
            // ignore: deprecated_member_use
            title: Container(),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.calculate,
          //     color: _selectedIndex == 3
          //         ? Colors.black
          //         : Colors.grey[500],             
          //   ),
          //   // ignore: deprecated_member_use
          //   title: Container(),
          // ),
        ],
      ),
    );
  }
}