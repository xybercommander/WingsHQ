// @dart=2.9
// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/pages/private_chat/private_chat.dart';

// Chat room list tile widget
class ChatRoomListTile extends StatefulWidget {
  final String chatRoomId;
  final String lastMessage;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  ChatRoomListTile(this.chatRoomId, this.lastMessage);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {

  // DatabaseMethods databaseMethods = DatabaseMethods();
  // String name = '', profilePic = '', lastMessage = '';
  String name = '';
  var names = [];

  ThemeData themeData;
  
  getThisUserName() async {  
    String username = "";  
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        username = value;
      });
    });
    names = widget.chatRoomId.split('_');
    int i = names.indexOf(username);
    i == 0 ? name = names[1] : name = names[0];
    setState(() {});
  }

  @override
  void initState() {     
    super.initState();
    getThisUserName();   
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (context) => PrivateChatScreen(name),        
      )),
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        // padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),          
        ),        
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Color(0xffc0e0ec),
              child: Text(name[0].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800])),
            ),
            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(
              widget.lastMessage.length > 30 ? widget.lastMessage.substring(0, 30) + '...' : widget.lastMessage, 
              style: TextStyle(fontSize: 14.0,fontFamily:"SF Pro", color: Colors.grey[700])
            ),
          ),
        ),
      ),
    );
  }
}