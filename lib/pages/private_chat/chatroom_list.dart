import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:hackmit/helper/helper_functions.dart';
import 'package:hackmit/services/database_service.dart';
import 'package:hackmit/shared/encryption_constants.dart';
import 'package:hackmit/widgets/chatRoomListTileWidget.dart';

class PrivateChatRoomList extends StatefulWidget {
  @override
  _PrivateChatRoomListState createState() => _PrivateChatRoomListState();
}

class _PrivateChatRoomListState extends State<PrivateChatRoomList> {

  DatabaseService databaseMethods = DatabaseService();
  Stream chatRoomsStream;
  bool isCompany;
  final encrypter = Encrypter(AES(EncryptionConstants.encryptionKey));    

  getChatRooms() async {
    String name = "";
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        name = value;
      });
    });
    chatRoomsStream = await databaseMethods.getChatRooms(name);
    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {        
        return snapshot.hasData ? ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.documents[index];
            // return Text(ds.id.replaceAll(CustomerConstants.fullName, '').replaceAll('_', ''));
            String message = encrypter.decrypt64(ds['lastMessage'], iv: EncryptionConstants.iv);
            return ChatRoomListTile(ds.documentID, message);
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

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(        
        title: Text('Chatroom List Page', style: TextStyle(fontSize: 27, color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),

      body: chatRoomsList()
    );
  }
}