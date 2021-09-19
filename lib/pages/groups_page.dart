// @dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/services/auth_service.dart';
import 'package:wings_hq/services/database_service.dart';
import 'package:wings_hq/widgets/group_tile.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({ Key key }) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // data
  final AuthService _auth = AuthService();
  FirebaseUser _user;
  String _groupName;
  String _groupDescription = '';
  String _userName = '';
  String _email = '';
  Stream _groups;


  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }


  // widgets
  Widget noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _popupDialog(context);
            },
            child: Icon(Icons.add_circle, color: Colors.grey[200], size: 75.0)
          ),
          SizedBox(height: 20.0),
          Text(
            "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      )
    );
  }



  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data['groups'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  int reqIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(userName: snapshot.data['fullName'], groupId: _destructureId(snapshot.data['groups'][reqIndex]), groupName: _destructureName(snapshot.data['groups'][reqIndex]));
                }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }


  // functions
  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }


  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }


  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }


  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed:  () async {
        if(_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName, _groupDescription);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group and give a one liner description"),
      content: Container(
        height: 300,
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                _groupName = val;
              },
              decoration: InputDecoration(
                hintText: 'Group Name',
                hintStyle: TextStyle(color: Colors.grey[700])
              ),
              style: TextStyle(
                fontSize: 15.0,
                height: 2.0,
                color: Colors.black             
              )
            ),
            TextField(
              onChanged: (val) {
                _groupDescription = val;
              },    
              keyboardType: TextInputType.multiline,          
              maxLength: 50,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Group Description',
                hintStyle: TextStyle(color: Colors.grey[700]),                
              ),
              style: TextStyle(
                fontSize: 15.0,
                height: 2.0,
                color: Colors.black             
              )
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcf9f3),
      // appBar: AppBar(
      //   title: Text('Groups', style: TextStyle(color: Color(0xffff7254), fontSize: 27.0, fontWeight: FontWeight.bold)),
      //   backgroundColor: Colors.transparent,
      //   iconTheme: IconThemeData(color: Color(0xffff7254)),
      //   elevation: 0.0,
      //   // leading: Icon(Icons.menu, color: Color(0xffff7254)),        
      // ),
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.black, size: 30.0),
        backgroundColor: Colors.grey[300],
        elevation: 0.0,
      ),
    );
  }
}