import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/conversation.dart';
import 'package:flutter_munasaka/viewmodel/all_users_viewmodel.dart';
import 'package:flutter_munasaka/viewmodel/chat_viewmodel.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    super.initState();
    _scrollController.addListener(_listScrollListener);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Kullanıcılar"),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child)  {
          if(model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                 if(model.usersList.length == 1) {
                    return _noUserAvailableUI();
                  } else if(model.hasMoreLoading &&
                      index == model.usersList.length) {
                    return _waitingNewUsersIndicator();
                  } else {
                    return _createUserListElement(index);
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.usersList.length+1
                    : model.usersList.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }


  Widget _noUserAvailableUI() {
    final _allUsersViewModel = Provider.of<AllUserViewModel>(context);

    return RefreshIndicator(
      onRefresh: _allUsersViewModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.supervised_user_circle,
                  color: Theme.of(context).primaryColor,
                  size: 120,
                ),
                Text("Kullanıcı Bulunmadı",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );

  }

  Widget _createUserListElement(int index) {

    final _userModel = Provider.of<FUserModel>(context, listen: false);
    final _allUserViewModel = Provider.of<AllUserViewModel>(context, listen: false);

    var _currentUser = _allUserViewModel.usersList[index];


    if(_currentUser.userID == _userModel.user!.userID) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => ChatViewModel(
                currentUser: _userModel.user!,
                contactUser: _currentUser,
              ),
              child: Conversation(),
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(_currentUser.userName as String),
          subtitle: Text(_currentUser.email as String),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_currentUser.profileURL as String),
          ),
        ),
      ),
    );

  }

  _waitingNewUsersIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
        child: Center(
          child:  CircularProgressIndicator(),
        ),
    );
  }

  void getMoreUsers() async {

    if(_isLoading == false) {
      _isLoading = true;
      final _allUserViewModel = Provider.of<AllUserViewModel>(context, listen: false);
      await _allUserViewModel.getMoreUsers();
      _isLoading = false;
    }
  }


  void _listScrollListener() {
    if(_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      getMoreUsers();
    }
  }
}

