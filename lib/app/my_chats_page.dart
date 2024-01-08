import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/conversation.dart';
import 'package:flutter_munasaka/model/chat.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/viewmodel/chat_viewmodel.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class MyChatsPage extends StatefulWidget {
  const MyChatsPage({super.key});

  @override
  State<MyChatsPage> createState() => _MyChatsPageState();
}

class _MyChatsPageState extends State<MyChatsPage> {

  @override
  Widget build(BuildContext context) {

    FUserModel _userModel = Provider.of<FUserModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbetlerim"),
      ),
      body: FutureBuilder<List<Chat>>(
        future: _userModel.getAllConversations(_userModel.user!.userID),
        builder: (context, chatList) {

          if(!chatList.hasData) {
            return Center(child: CircularProgressIndicator(),);
          } else {

            var allChats = chatList.data;

            if(allChats != null && allChats.length > 0) {

              return RefreshIndicator(
                onRefresh: _refreshMyChats,
                child: ListView.builder(
                    itemCount: allChats.length,
                    itemBuilder: (context, index) {
                      var currentChat = allChats[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(
                              MaterialPageRoute(builder: (context) =>
                                  ChangeNotifierProvider(
                                    create: (context) => ChatViewModel(
                                      currentUser: _userModel.user!,
                                      contactUser: FUser.idAndProfileURL(
                                          userID: currentChat.chatWith,
                                          profileURL: currentChat.chattedUserProfileURL
                                      ),
                                    ),
                                    child: Conversation(),
                                  ),
                              )
                          );
                        },
                        child: ListTile(
                          title: Text(currentChat.lastMessage),
                          subtitle: Text(
                              "${currentChat.chattedUserUserName} - "
                                  "${currentChat.lastReadDateToString}"
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(currentChat.chattedUserProfileURL!),
                          ),
                        ),
                      );
                    }
                ),
              );


            } else {
              return RefreshIndicator(
                onRefresh: _refreshMyChats,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.chat_bubble_outline,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text("Sohbet Bulunamadı",
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



          }
        },
      ),
    );
  }



  Future<void> _refreshMyChats() async {

    setState(() {

    });
    await Future.delayed(Duration(seconds: 1));
  }
}

