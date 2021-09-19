// @dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wings_hq/pages/chat_page.dart';
import 'package:wings_hq/services/database_service.dart';

class HomePageGroupTile extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupDescription;
  final String admin;
  final String userName;
  final FirebaseUser user;

  HomePageGroupTile({this.groupId, this.groupName, this.admin, this.userName, this.user, this.groupDescription});

  @override
  State<HomePageGroupTile> createState() => _HomePageGroupTileState();
}

class _HomePageGroupTileState extends State<HomePageGroupTile> {

  bool _isJoined = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        duration: Duration(milliseconds: 1500),
        content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0,fontFamily:"SF Pro")),
      )
    );
  }


  _joinValueInGroup(String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: widget.user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  @override
  void initState() {    
    _joinValueInGroup(widget.userName, widget.groupId, widget.groupName, widget.admin);
    super.initState();    
  }


  // @override
  // void dispose() {    
  //   super.dispose();
  //   _isJoined = false;
  // }

  
  @override
  Widget build(BuildContext context) {    
    return GestureDetector(
      // onTap: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
      // },
      child: Container(
        height: 100,
        width: 200,
        margin: EdgeInsets.only(top: 8, bottom: 8, right: 8),
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black38)
        ),      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Color(0xffc0e0ec),
                  child: Text(widget.groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: 24)),
                ),
                InkWell(
                  onTap: () async {                    
                    await DatabaseService(uid: widget.user.uid).togglingGroupJoin(widget.groupId, widget.groupName, widget.userName);
                    await _joinValueInGroup(widget.userName, widget.groupId, widget.groupName, widget.admin);
                    print('CHECK THIS ---> ' + _isJoined.toString());
                    if(_isJoined) {
                      // setState(() {                        
                      //   _isJoined = !_isJoined;
                      // });
                      // await DatabaseService(uid: user.uid).userJoinGroup(groupId, groupName, userName);
                      // _showScaffold('Successfully joined the group "${widget.groupName}"');
                      // Future.delayed(Duration(milliseconds: 2000), () {
                        
                      // });
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: widget.groupId, userName: widget.userName, groupName: widget.groupName)));
                    }
                    else {
                      setState(() {
                        _isJoined = !_isJoined;
                      });
                      // _showScaffold('Left the group "${widget.groupName}"');
                    }
                  },
                  child: _isJoined ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black87,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0
                      )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text('Joined', style: TextStyle(color: Colors.white,fontFamily:"SF Pro")),
                  )
                  :
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text('Join', style: TextStyle(color: Colors.white,fontFamily:"SF Pro")),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Text(widget.groupName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22)),
            SizedBox(height: 2,),
            Text(
              widget.groupDescription ?? '', 
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.0,fontFamily:"SF Pro", color: Colors.black)
            ),
          ],
        ),
      ),
    );
  }
}