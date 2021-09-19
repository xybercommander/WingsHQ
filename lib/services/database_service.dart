// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference groupCollection = Firestore.instance.collection('groups');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      // 'password': password, // Dont save password for privacy
      'groups': [],
      'profilePic': ''
    });
  }


  getRecentGroupsCreated() {
    return Firestore.instance.collection('groups')            
      .orderBy('createdOn', descending: true)
      .snapshots();
  }

  // create group
  Future createGroup(String userName, String groupName, String groupDescription) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupIcon': '',
      'createdOn': DateTime.now(),
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName]),
        'groupId': groupDocRef.documentID
    });

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'groups': FieldValue.arrayUnion([groupDocRef.documentID + '_' + groupName])
    });
  }


  // toggling the user group join
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.document(groupId);

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if(groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    }
    else {
      //print('nay');
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }


  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    
    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }


  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }


  // get user groups
  getUserGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance.collection("users").document(uid).snapshots();
  }

  // Leave Group
  leaveGroup({String groupId, String groupName, String username}) async {
    print(uid);
    DocumentReference userDocRef = userCollection.document(uid);
    userDocRef.updateData({
      'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
    });    

    DocumentReference groupDocRef = groupCollection.document(groupId);
    groupDocRef.updateData({
      'members': FieldValue.arrayRemove([uid + '_' + username])
    });
    
  }


  // send message
  sendMessage(String groupId, chatMessageData) {
    Firestore.instance.collection('groups').document(groupId).collection('messages').add(chatMessageData);
    Firestore.instance.collection('groups').document(groupId).updateData({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }


  // get chats of a particular group
  getChats(String groupId) async {
    return Firestore.instance.collection('groups')
      .document(groupId)
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots();
  }


  // search groups
  searchByName(String groupName) {
    return Firestore.instance.collection("groups").where('groupName', isEqualTo: groupName).getDocuments();
  }  

  // get professionals
  getProfessionals() {
    return Firestore.instance.collection("professionals").snapshots();
  }


  // adding a message to chats sub-collection of chatrooms collection
  Future addMessage(String chatRoomId, String messageId, Map messageInfoMap) {
    return Firestore.instance.collection('chatrooms')
      .document(chatRoomId)
      .collection('chats')
      .document(messageId)      
      .setData(messageInfoMap);
  }

  // Updating the last message sent collections
  updateLastMessageSent(String chatRoomId, Map lastMessageInfoMap) {
    return Firestore.instance.collection('chatrooms')
      .document(chatRoomId)
      .updateData(lastMessageInfoMap);
  }

  // Creating or searching for new or existing chatrooms
  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapshot = await Firestore.instance.collection('chatrooms')
      .document(chatRoomId)
      .get();

    if(snapshot.exists) {
      // if chatroom exists
      return true;
    } else {
      // if chatroom does not exist
      return Firestore.instance.collection('chatrooms')
        .document(chatRoomId)
        .setData(chatRoomInfoMap);
    }
  }

  // retrieving the chat messages
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return Firestore.instance.collection('chatrooms')
      .document(chatRoomId)
      .collection('chats')
      .orderBy('ts', descending: true)
      .snapshots();
  }

  // Getting the list of all the chatrooms created
  Future<Stream<QuerySnapshot>> getChatRooms(String name) async {        
    return Firestore.instance.collection('chatrooms')
      .orderBy('lastMessageSentTs', descending: true)
      .where('users', arrayContains: name)
      .snapshots();
  }
}