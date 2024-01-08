import 'dart:io';
import 'package:flutter_munasaka/locator.dart';
import 'package:flutter_munasaka/model/chat.dart';
import 'package:flutter_munasaka/model/message.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/services/auth_base.dart';
import 'package:flutter_munasaka/services/fake_auth_service.dart';
import 'package:flutter_munasaka/services/firebase_auth_service.dart';
import 'package:flutter_munasaka/services/firebase_storage_service.dart';
import 'package:flutter_munasaka/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class FUserRepository implements AuthBase {

  // It has to be Future.value(value), it will not accept plain null or false
  // Because of returning type are Future<bool> and Future<FUser?>

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService = locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<FUser> allUsersList = [];

  @override
  Future<FUser?> currentUser() async {
    if(appMode == AppMode.DEBUG)
      return await _fakeAuthenticationService.currentUser();
    else {
      //return await _firebaseAuthService.currentUser();
      FUser? _user =  await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  @override
  Future<FUser?> signInAnonymously() async {
    if(appMode == AppMode.DEBUG)
      return await _fakeAuthenticationService.signInAnonymously();
    else
      return await _firebaseAuthService.signInAnonymously();
  }

  @override
  Future<bool> signOut() async {
    if(appMode == AppMode.DEBUG)
      return await _fakeAuthenticationService.signOut();
    else
      return await _firebaseAuthService.signOut();
  }

  @override
  Future<FUser?> signInWithGoogle() async {
    if(appMode == AppMode.DEBUG)
      return await _fakeAuthenticationService.signInWithGoogle();
    else {
      FUser? _user =  await _firebaseAuthService.signInWithGoogle();
      bool result = await _firestoreDBService.saveUser(_user!);
      if(result) {
        return _user;
      } else {
        return null;
      }
    }
  }

  @override
  Future<FUser?> createUserWithEmailandPassword(String email, String password) async {
    if(appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService
          .createUserWithEmailandPassword(email, password);
    } else {
        FUser? _user =  await _firebaseAuthService
            .createUserWithEmailandPassword(email, password);
        bool result = await _firestoreDBService.saveUser(_user!);
        if(result) {
          return await _firestoreDBService.readUser(_user.userID);
        } else {
          return null;
        }
    }
  }

  @override
  Future<FUser?> signInWithEmailandPassword(String email, String password) async {
    if(appMode == AppMode.DEBUG)
      return await _fakeAuthenticationService
          .signInWithEmailandPassword(email, password);
    else {
        FUser? _user = await _firebaseAuthService.signInWithEmailandPassword(email, password);
        return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {

    if(appMode == AppMode.DEBUG)
      return false;
    else {
    return await _firestoreDBService.updateUsername(userID, newUserName);
    }

  }

  Future<String> uploadFile(String userID, String fileType, File file) async {

    if(appMode == AppMode.DEBUG)
      return "dosya indirme linki";
    else {
      var profilePhotoURL = await _firebaseStorageService.uploadFile(userID, fileType, file);
      await _firestoreDBService.updateProfilePhoto(userID, profilePhotoURL);
      return profilePhotoURL;
    }

  }

  Stream<List<Message>> getMessages(String currentUserID, String contactUserID) {

    if(appMode == AppMode.DEBUG) {
      return Stream.empty();
    }
    else {
      return _firestoreDBService.getMessages(currentUserID, contactUserID);
    }

  }

  Future<bool> saveMessage(Message toBeSavedMessage) async {

    if(appMode == AppMode.DEBUG) {
      return Future.value(true);
    }
    else {
      return await _firestoreDBService.saveMessage(toBeSavedMessage);
    }

  }

  Future<List<Chat>> getAllConversations(String userID) async {

    if(appMode == AppMode.DEBUG) {
      return [];
    }
    else {

      DateTime _date = await _firestoreDBService.showTime(userID);

      var _chatList = await _firestoreDBService.getAllConversations(userID);

      for(var currentChat in _chatList) {
        var currentUser = findUserInList(currentChat.chatWith);
        if(currentUser != null) {
          //print("DATA RECEIVED FROM LOCAL CACHE");
          currentChat.chattedUserUserName = currentUser.userName;
          currentChat.chattedUserProfileURL = currentUser.profileURL;
        } else {
          //print("DATA RECEIVED FROM REMOTE DATABASE");
          var _readUserFromDB  = await _firestoreDBService.readUser(currentChat.chatWith);
          currentChat.chattedUserUserName = _readUserFromDB.userName;
          currentChat.chattedUserProfileURL = _readUserFromDB.profileURL;
        }

        calculateTimeAgo(currentChat, _date);

      }
      return _chatList;

    }

  }

  FUser? findUserInList(String usedID) {

    for(int i = 0; i < allUsersList.length; i++) {
      if(allUsersList[i].userID == usedID) {
        return allUsersList[i];
      }
    }

    return null;
  }

  void calculateTimeAgo(Chat currentChat, DateTime date) {

    currentChat.lastReadDate = date;
    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = date.difference(currentChat.creationTimestamp!
        .toDate());
    currentChat.lastReadDateToString = timeago
        .format(date.subtract(_duration), locale: "tr");

  }

  Future<List<FUser>> getUserWithPagination(FUser? lastUser, int numberOfElementsToLoad) async {

    if(appMode == AppMode.DEBUG) {
      return [];
    }
    else {
      List<FUser> _tempUserList = await _firestoreDBService
          .getUserWithPagination(lastUser, numberOfElementsToLoad);
      allUsersList.addAll(_tempUserList);
      return _tempUserList;
    }

  }


  Future<List<Message>> getChatWithPagination(String currentUserID,
      String contactUserID, Message? lastMessage,
      int numberOfElements) async {

    if(appMode == AppMode.DEBUG) {
      return [];
    }
    else {
      return await _firestoreDBService
          .getChatWithPagination(currentUserID, contactUserID, lastMessage,
          numberOfElements);

    }

  }

}