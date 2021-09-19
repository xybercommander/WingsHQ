// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/services/database_service.dart';
import 'package:wings_hq/shared/encryption_constants.dart';
import 'package:wings_hq/widgets/message_tile.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatWithName;  
  PrivateChatScreen(this.chatWithName);

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {

  String chatRoomId, messageId = '';
  String myName, profilePic, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();

  DatabaseService databaseMethods = DatabaseService();
  Stream messageStream;

  final encrypter = Encrypter(AES(EncryptionConstants.encryptionKey));
  

  // Initial functions to be executed
  getChatRoomId(String a, String b) {
    if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getMyInfo() async {    
    myName = await HelperFunctions.getUserNameSharedPreference();    
    myEmail = await HelperFunctions.getUserEmailSharedPreference();
    chatRoomId = getChatRoomId(widget.chatWithName, myName);
  }

  doThisOnLaunch() async {
    await getMyInfo();
    getAndSetMessages();
  }// Initial functions ended



  // Chat room functions
  Widget chatBubble(String text, bool sendByMe) {
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(              
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),        
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(sendByMe ? 0 : 20),
            bottomLeft: Radius.circular(!sendByMe ? 0 : 20),
          ),
          gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  sendByMe ? Color.fromRGBO(223, 140, 112, 1) : Color.fromRGBO(194, 200, 197, 1),
                  sendByMe ? Color.fromRGBO(250, 89, 143, 1) : Color.fromRGBO(221, 221, 218, 1),
                ])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: TextStyle(color: sendByMe ? Colors.white : Colors.blueGrey[900]),),
          ),
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: true,
          padding: EdgeInsets.only(bottom: 80),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.documents[index]; 

            String message = encrypter.decrypt64(ds['message'], iv: EncryptionConstants.iv);           

            // return chatBubble(message, myName == ds['sendBy']);
            return MessageTile(
              message: message, 
              sentByMe: myName == ds['sendBy'], 
              sender: myName == ds['sendBy'] ? myName : widget.chatWithName,
            );
          },
        ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [              
              Text('Seems empty')
            ],
          ),
        );
      },
    );
  }


  getAndSetMessages() async {
    messageStream = await databaseMethods.getChatRoomMessages(chatRoomId);
    setState(() {}); // setting the state after fetching the messages
  }


  // synchronizing the messages
  addMessage(bool sendClicked) {
    if(messageTextEditingController.text != '') {
            
      final encrypted = encrypter.encrypt(messageTextEditingController.text, iv: EncryptionConstants.iv);
      String message = encrypted.base64;
      var lastMessageTimeStamp = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        'message' : message,
        'sendBy' : myName,
        'ts' : lastMessageTimeStamp //  the timestamp of the msg
      };

      if(messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      databaseMethods.addMessage(chatRoomId, messageId, messageInfoMap)
        .then((value) {
          Map<String, dynamic> lastMessageInfoMap = {
            'lastMessage': message,
            'lastMessageSentTs' : lastMessageTimeStamp,
            'lastMessageSentBy' : myName
          };   

          databaseMethods.updateLastMessageSent(chatRoomId, lastMessageInfoMap);      

          if(sendClicked) {
            // remove the text
            messageTextEditingController.text = '';    
            messageId = '';
          }
        });
    }
  }  


  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.chatWithName),
      //   backgroundColor: Color.fromRGBO(223, 140, 112, 1),        
      // ),
      appBar: AppBar(
        title: Text(widget.chatWithName, style: TextStyle(color: Colors.white,fontFamily:"SF Pro")),
        centerTitle: true,
        // backgroundColor: Color(0xffff7254).withOpacity(0.8),
        backgroundColor: Color(0xff150050),
        elevation: 0.0,
      ),

      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.black
                // image: DecorationImage(
                //   image: AssetImage('images/chat-bg.jpg'),
                //   fit: BoxFit.cover,
                //   colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2),BlendMode.color)
                // ),
              ),
              child: Image.asset(
                'images/chat-bg.jpg',
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            chatMessages(),
            Align(
              alignment: Alignment.bottomCenter,              
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),                
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(width: 2, color: Color(0xff610094)),
                  color: Color(0xff212121),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextEditingController,
                        style: TextStyle(
                          color: Colors.purple[200]
                        ),
                        decoration: InputDecoration(
                          hintText: "Send a message ...",
                          hintStyle: TextStyle(
                            color: Colors.purple[300],
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
                        addMessage(true);
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff212121),
                          border: Border.all(width: 3, color: Colors.purple[300])
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