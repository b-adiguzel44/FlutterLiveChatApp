import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_munasaka/model/chat.dart';
import 'package:flutter_munasaka/model/message.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/services/database_base.dart';

class FirestoreDBService implements DBBase {

  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;


  @override
  Future<bool> saveUser(FUser user) async {


    await _firebaseDB
        .collection("users")
        .doc(user.userID)
        .set(user.toMap());

    return true;
  }

  @override
  Future<FUser> readUser(String userID) async {

    DocumentSnapshot _readUser = await _firebaseDB
        .collection("users")
        .doc(userID)
        .get();

    var _readedUserInfo = _readUser.data();
    FUser _readUserObj = FUser.fromMap(_readedUserInfo! as Map<String, dynamic>);
    //print("Readed User info :\n ${_readUserObj.toString()}");
    return _readUserObj;
  }

  @override
  Future<bool> updateUsername(String userID, String newUserName) async {

    var users = await _firebaseDB.collection("users")
        .where("userName", isEqualTo: newUserName).get();
    if(users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB.collection("users")
          .doc(userID)
          .update({"userName": newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL) async {
      await _firebaseDB.collection("users")
          .doc(userID)
          .update({"profileURL": profilePhotoURL});
      return true;
  }

  @override
  Future<List<Chat>> getAllConversations(String userID) async {

    QuerySnapshot querySnapshot = await _firebaseDB
        .collection("conversations")
        .where("chatOwner", isEqualTo: userID)
        .orderBy("creation_timestamp", descending: true)
        .get();

    List<Chat> allConversations = [];

    for(DocumentSnapshot singleChat in querySnapshot.docs) {
      // TODO : For DEBUG Purposes
      //print("Single Chat \n:${singleChat.data()}");
      Chat _chat = Chat.fromMap(singleChat.data() as Map<String, dynamic>);
      allConversations.add(_chat);
    }

    return allConversations;
  }


  @override
  Stream<List<Message>> getMessages(String currentUserID, String contactUserID)  {
      var snapShot = _firebaseDB
          .collection("conversations")
          .doc(currentUserID+"--"+contactUserID)
          .collection("chats")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .snapshots()
        .handleError((error) => print("Error fetching data: $error"));

    // TODO : For DEBUG Purposes
    //snapShot.forEach((e) => e.docs.forEach((e) => print(e.data.toString())));

    return snapShot.map((messagesList) => messagesList.docs
        .map((message) => Message.fromMap(message.data()))
        .toList()
    );
  }

  @override
  Future<bool> saveMessage(Message toBeSavedMessage) async {

    var _messageID = _firebaseDB.collection("conversations").doc().id;
    var _myDocumentID = toBeSavedMessage.senderId + "--" + toBeSavedMessage.receiverId;
    var _receiverDocumentID = toBeSavedMessage.receiverId + "--" + toBeSavedMessage.senderId;
    var _saveMessageMap = toBeSavedMessage.toMap();

    await _firebaseDB
        .collection("conversations")
        .doc(_myDocumentID)
        .collection("chats")
        .doc(_messageID)
        .set(_saveMessageMap);

    await _firebaseDB
        .collection("conversations").doc(_myDocumentID).set({
      "chatOwner": toBeSavedMessage.senderId,
      "chatWith": toBeSavedMessage.receiverId,
      "lastMessage": toBeSavedMessage.message,
      "seen": false,
      "creation_timestamp": FieldValue.serverTimestamp()
    });


    _saveMessageMap.update("isMe", (value) => false);

    await _firebaseDB
        .collection("conversations")
        .doc(_receiverDocumentID)
        .collection("chats")
        .doc(_messageID)
        .set(_saveMessageMap);

    await _firebaseDB
        .collection("conversations").doc(_receiverDocumentID).set({
      "chatOwner": toBeSavedMessage.receiverId,
      "chatWith": toBeSavedMessage.senderId,
      "lastMessage": toBeSavedMessage.message,
      "seen": false,
      "creation_timestamp": FieldValue.serverTimestamp()
    });



    return true;
  }

  @override
  Future<DateTime> showTime(String userID) async {

    await _firebaseDB.collection("server").doc(userID).set({
      "time": FieldValue.serverTimestamp(),

    });

    var _dateInfoFromServer = await _firebaseDB.collection("server").doc(userID).get();
    Timestamp _dateTime = _dateInfoFromServer.data()!["time"];
    return _dateTime.toDate();

  }

  @override
  Future<List<FUser>> getUserWithPagination(FUser? lastUser, int numberOfElementsToLoad) async {

    QuerySnapshot _querySnapshot;
    List<FUser> _allUsers = [];

    if(lastUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(numberOfElementsToLoad)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([lastUser.userName])
          .limit(numberOfElementsToLoad)
          .get();
      await Future.delayed(Duration(seconds: 1));
    }


    for(DocumentSnapshot snap in _querySnapshot.docs) {
      FUser _singleUser = FUser.fromMap(snap.data() as Map<String, dynamic>);
      _allUsers.add(_singleUser);
    }

    return _allUsers;
  }

  Future<List<Message>> getChatWithPagination(String currentUserID,
      String contactUserID, Message? lastMessage,int numberOfElements) async {


    QuerySnapshot _querySnapshot;
    List<Message> _allChats = [];

    if(lastMessage == null) {
      _querySnapshot = await _firebaseDB
          .collection("conversations")
          .doc(currentUserID+"--"+contactUserID)
          .collection("chats")
          .orderBy("timestamp", descending: true)
          .limit(numberOfElements)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection("conversations")
          .doc(currentUserID+"--"+contactUserID)
          .collection("chats")
          .orderBy("timestamp", descending: true)
          .startAfter([lastMessage.timestamp])
          .limit(numberOfElements)
          .get();
      await Future.delayed(Duration(seconds: 1));
    }


    for(DocumentSnapshot snap in _querySnapshot.docs) {
      Message _singleMessage = Message.fromMap(snap.data() as Map<String, dynamic>);
      _allChats.add(_singleMessage);
    }

    return _allChats;

  }


  
}