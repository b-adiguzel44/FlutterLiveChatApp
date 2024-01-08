import 'package:flutter_munasaka/model/chat.dart';
import 'package:flutter_munasaka/model/message.dart';
import 'package:flutter_munasaka/model/user_model.dart';

abstract class DBBase {

  Future<bool> saveUser(FUser user);
  Future<FUser> readUser(String userID);
  Future<bool> updateUsername(String userID, String newUserName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL);
  Future<List<FUser>> getUserWithPagination(FUser? lastUser, int numberOfElementsToLoad);
  Future<List<Chat>> getAllConversations(String userID);
  Stream<List<Message>> getMessages(String currentUserID, String contactUserID);
  Future<bool> saveMessage(Message toBeSavedMessage);
  Future<DateTime> showTime(String userID);
}