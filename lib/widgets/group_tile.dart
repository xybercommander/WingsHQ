// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hackmit/pages/chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          // border: Border.all(color: Colors.black38, width: 0.5),
          borderRadius: BorderRadius.circular(10),          
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Color(0xffc0e0ec),
            child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800])),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text("Join the conversation as $userName", style: TextStyle(fontSize: 13.0,fontFamily:"SF Pro", color: Colors.grey[700])),
        ),
      ),
    );
  }
}