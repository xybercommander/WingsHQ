// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wings_hq/services/database_service.dart';
import 'package:wings_hq/shared/encryption_constants.dart';
import 'package:wings_hq/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  FirebaseUser _user;

  final encrypter = Encrypter(AES(EncryptionConstants.encryptionKey));

  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget leaveButton = FlatButton(
      child: Text("Leave"),
      onPressed:  () {
        DatabaseService(uid: _user.uid).leaveGroup(
          groupId: widget.groupId,
          groupName: widget.groupName,
          username: widget.userName
        );
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: Text(
        'Are you sure you want to leave the group?',
        style: TextStyle(
          color: Color(0xffff7254)
        ),
      ),
      actions: [
        cancelButton,
        leaveButton,
      ],
    );
        
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: true,
          padding: EdgeInsets.only(bottom: 90),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){

            String message = encrypter.decrypt64(
              snapshot.data.documents[index].data["message"], 
              iv: EncryptionConstants.iv
            );

            return MessageTile(
              message: message,
              sender: snapshot.data.documents[index].data["sender"],
              sentByMe: widget.userName == snapshot.data.documents[index].data["sender"],
            );
          }
        )
        :
        Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {

      final encrypted = encrypter.encrypt(messageEditingController.text, iv: EncryptionConstants.iv);
      String message = encrypted.base64;

      Map<String, dynamic> chatMessageMap = {
        "message": message,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.black,fontFamily:"SF Pro")),
        centerTitle: true,
        // backgroundColor: Color(0xffff7254).withOpacity(0.8),
        backgroundColor: Color(0xffc0e0ec),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () => _popupDialog(context),
            icon: Icon(Icons.logout_outlined, color: Colors.black)
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white
                // image: DecorationImage(
                //   image: AssetImage('images/chat-bg.jpg'),
                //   fit: BoxFit.cover,
                //   colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2),BlendMode.color)
                // ),
              ),
              child: Image.asset(
                'images/chat-bg.jpg',
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,              
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),                
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(width: 2, color: Color(0xff610094)),
                  // color: Color(0xff212121),
                  color: Colors.grey[800]
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(
                          color: Colors.grey[200]
                        ),
                        decoration: InputDecoration(
                          hintText: "Send a message ...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily:"SF Pro"
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[800],
                          border: Border.all(width: 2, color: Colors.white)
                        ),
                        child: Center(
                          child: Image.asset('images/send.png', height: 20, width: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
