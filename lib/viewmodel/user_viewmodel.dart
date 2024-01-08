import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_munasaka/locator.dart';
import 'package:flutter_munasaka/model/chat.dart';
import 'package:flutter_munasaka/model/message.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/repository/user_repository.dart';
import 'package:flutter_munasaka/services/auth_base.dart';

enum ViewState { Idle, Busy }


class FUserModel with ChangeNotifier implements AuthBase {

  ViewState _state = ViewState.Idle;
  FUserRepository _userRepository = locator<FUserRepository>();
  FUser? _user;
  String? emailErrorMessage;
  String? passwordErrorMessage;


  FUser? get user => _user;
  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  FUserModel() {
    currentUser();
  }

  @override
  Future<FUser?> currentUser() async {

    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch(e) {
      debugPrint("error occured at currentUser method in FUserModel(ViewModel) : $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }

  }

  @override
  Future<FUser?> signInAnonymously() async {

    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch(e) {
      debugPrint("error occured at signInAnonmyously method in FUserModwl : $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }

  }

  @override
  Future<bool> signOut() async {

    try {
      state = ViewState.Busy;
      _user = null;
      return await _userRepository.signOut();
    } catch(e) {
      debugPrint("error occured at signOut method in FUserModwl : $e");
      return false;
    } finally {
      state = ViewState.Idle;
    }

  }

  @override
  Future<FUser?> signInWithGoogle() async {

    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch(e) {
      debugPrint("error occured at signInWithGoogle method in FUserModel : $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }

  }

  @override
  Future<FUser?> createUserWithEmailandPassword(String email, String password) async {


      if(_emailPasswordControl(email, password) == true) {
        try {
          state = ViewState.Busy;
          _user = await _userRepository.createUserWithEmailandPassword(email, password);
          return _user;
        } finally {
          state = ViewState.Idle;
        }
      } else {
        return null;
      }


  }

  @override
  Future<FUser?> signInWithEmailandPassword(String email, String password) async {

    try {
      if(_emailPasswordControl(email, password) == true) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailandPassword(email, password);
        return _user;
      } else {
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }

  }

  bool _emailPasswordControl(String email, String password) {

    var result = true;

    if(password.length < 6) {
      passwordErrorMessage = "Şifre en az 6 karakter olmalıdır.";
      result = false;
    } else passwordErrorMessage = null;
    if(!email.contains("@")) {
      emailErrorMessage = "Geçersiz email adresi";
      result = false;
    } else emailErrorMessage = null;

    return result;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {

    //state = ViewState.Busy;
    var result = await _userRepository.updateUserName(_user!.userID, newUserName);
    //state = ViewState.Idle;
    if(result == true) {
      _user!.userName = newUserName;
    }
    return result;

  }

  Future<bool?> uploadFile(String userID, String fileType, File file) async {

    var downloadLink = await _userRepository.uploadFile(userID, fileType, file);
    return true;

  }

  Stream<List<Message>> getMessages(String currentUserID, String contactUserID) {

    return _userRepository.getMessages(currentUserID, contactUserID);

  }

  Future<List<Chat>> getAllConversations(String userID) async {
    return await _userRepository.getAllConversations(userID);
  }

  Future<List<FUser>> getUserWithPagination(FUser? lastUser, int numberOfElementsToLoad) async {
    return await _userRepository.getUserWithPagination(lastUser, numberOfElementsToLoad);
  }


}