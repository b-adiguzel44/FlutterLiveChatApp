import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_munasaka/locator.dart';
import 'package:flutter_munasaka/model/message.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/repository/user_repository.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {

  List<Message>? _allChats;
  ChatViewState _state = ChatViewState.Idle;
  static final messageLimit = 20;
  FUserRepository _userRepository = locator<FUserRepository>();
  final FUser currentUser;
  final FUser contactUser;
  Message? _lastMessage;
  Message? _firstMessageInList;
  bool _hasMore = true;
  bool _newMessageListener = false;
  StreamSubscription? _streamSubscription;

  ChatViewModel({required this.currentUser, required this.contactUser}) {
    _allChats = [];
    getChatWithPagination(false);
  }

  @override
  dispose() {
    //print("Chatviewmodel dispose edildi");
    _streamSubscription?.cancel();
    super.dispose();
  }

  List<Message> get messagesList => _allChats!;

  ChatViewState get state => _state;
  bool get hasMoreLoading => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> saveMessage(Message toBeSavedMessage) async {
    return _userRepository.saveMessage(toBeSavedMessage);
  }

  void getChatWithPagination(bool areLoadingNewMessages) async {


    if(_allChats!.length > 0) {
      _lastMessage = _allChats!.last;
    }

    if(!areLoadingNewMessages) {
      state = ChatViewState.Busy;
    }

    var _allChatsFromDB = await _userRepository.getChatWithPagination(
        currentUser.userID,
        contactUser.userID,
        _lastMessage,
        messageLimit);

    if(_allChatsFromDB.length < messageLimit) {
      _hasMore = false;
    }

    //_allChatsFromDB.forEach((msg) => print("Getirilen Mesajlar : ${msg.message}"));

    _allChats!.addAll(_allChatsFromDB);
    if(_allChats!.length > 0)
      _firstMessageInList = _allChats!.first;

    //print("Listeye eklenen ilk mesaj : ${_firstMessageInList?.message}");
    state = ChatViewState.Loaded;

    if(_newMessageListener == false) {
      _newMessageListener = true;
      //print("NO_LISTENER - CREATING A LISTENER");
      assignNewMessageListener();
    }

  }


  Future<void> loadMoreMessages() async {
    //print("loadMoreMessages() invoked in chat_viewmodel.dart");
    if(_hasMore) {
      getChatWithPagination(true);
    } else {
      //print("No more messages available to load");
    }
    await Future.delayed(Duration(seconds: 2));
  }

  void assignNewMessageListener() {

    //print("A listener assigned for new messages");
    _streamSubscription = _userRepository
        .getMessages(currentUser.userID, contactUser.userID)
    .listen((currentData) {

      if(currentData.isNotEmpty) {

        //print("listener triggered - last data received : ${currentData[0]}");

        if(currentData[0].timestamp != null) {

          // First time - someone is sending a message to someone
          if(_firstMessageInList == null) {
            _allChats!.insert(0, currentData[0]);
          } else if(_firstMessageInList!.timestamp!.millisecondsSinceEpoch
              != currentData[0].timestamp!.millisecondsSinceEpoch) {
            _allChats!.insert(0, currentData[0]);
          }

        }
        state = ChatViewState.Loaded;
      }

    });
  }




}