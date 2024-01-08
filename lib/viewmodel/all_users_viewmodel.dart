import 'package:flutter/material.dart';
import 'package:flutter_munasaka/locator.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/repository/user_repository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {

  AllUserViewState _state = AllUserViewState.Idle;
  late List<FUser> _allUsers;
  FUser? _lastUser;
  static final userLimit = 10;
  FUserRepository _userRepository = locator<FUserRepository>();
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  List<FUser> get usersList => _allUsers;
  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _allUsers = [];
    _lastUser = null;
    getUserWithPagination(_lastUser, false);
  }

  // For refresh and pagination processes
  // areMoreUsersLoading will be returned as true
  // for Initilization for first time, areMoreUsersLoading will be returned as false
  getUserWithPagination(FUser? lastUser, bool areMoreUsersLoading) async {

    if(_allUsers.length > 0) {
      _lastUser = _allUsers.last;
      //print("Last User: ${_lastUser!.userName}");
    }

    if(areMoreUsersLoading) {
    } else {
      state = AllUserViewState.Busy;
    }


    var _newList = await _userRepository.getUserWithPagination(_lastUser, userLimit);

    if(_newList.length < userLimit) {
      _hasMore = false;
    }

    _newList.forEach((usr) =>  print("Received Username : ${usr.userName}"));

    _allUsers.addAll(_newList);
    state = AllUserViewState.Loaded;
  }

  Future<void> getMoreUsers() async {
    if(_hasMore) {
      getUserWithPagination(_lastUser, true);
    }
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> refresh() async {
    _hasMore = true;
    _lastUser = null;
    _allUsers = [];
    getUserWithPagination(_lastUser, true);
    await Future.delayed(Duration(seconds: 2));
  }

}