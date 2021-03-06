// @dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTile extends StatefulWidget {

  final String message;
  final String sender;
  final bool sentByMe;

  MessageTile({this.message, this.sender, this.sentByMe});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  bool isMsgUrl = false;
  checkIfMessageIsUrl() {
    if(widget.message.length >= 4 && (widget.message.substring(0, 4) == 'http' || widget.message.substring(0, 5) == 'https')) {
      setState(() {
        isMsgUrl = true;
      });
    }
  }

  @override
  void initState() {    
    super.initState();
    checkIfMessageIsUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0),
        alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
          decoration: BoxDecoration(
          borderRadius: widget.sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15)
          )
          :
          BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15)
          ),
          color: widget.sentByMe ? Colors.grey[500] : Color(0xffc0e0ec),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Text(
              widget.sentByMe 
                  ? "You"
                  : widget.sender.toUpperCase(), 
              textAlign: TextAlign.start, 
              style: TextStyle(
                fontSize: 14.0, 
                fontWeight: FontWeight.bold, 
                color: widget.sentByMe ? Colors.black : Colors.black, 
                letterSpacing: -0.5
              )
            ),
            SizedBox(height: 7.0),
            GestureDetector(
              onTap: () {
                if(isMsgUrl) {
                  launch(widget.message);
                }
              },
              child: Text(
                widget.message, 
                textAlign: TextAlign.start, 
                style: TextStyle(
                  fontSize: 15.0, color: isMsgUrl ? Colors.purple : Colors.black
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}