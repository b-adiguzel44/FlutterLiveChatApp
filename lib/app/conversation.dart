import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_munasaka/model/message.dart';
import 'package:flutter_munasaka/viewmodel/chat_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Conversation extends StatefulWidget {

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  var _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

  }


  @override
  Widget build(BuildContext context) {

    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(child: CircularProgressIndicator(),)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                  _buildMessageList(),
                  _buildTypeNewMessage(),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: chatModel.hasMoreLoading
                      ? chatModel.messagesList.length+1
                      : chatModel.messagesList.length,
                  itemBuilder: (context, index) {

                    if(chatModel.hasMoreLoading && chatModel.messagesList.length == index) {
                      return _loadingNewMessagesIndicator();
                    } else {

                    }

                    return _buildConversationBalloon(chatModel.messagesList[index]);
                  },
          ),
        );
      },
    );

  }

  Widget _buildTypeNewMessage() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.blueGrey,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Mesajınızı yazınız",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 4
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,),
                      onPressed: () async {

                        if(_messageController.text.trim().length > 0) {

                          Message _toBeSavedMessage = Message(
                            senderId: _chatModel.currentUser.userID,
                            receiverId: _chatModel.contactUser.userID,
                            isMe: true,
                            message: _messageController.text,
                          );

                          var result =
                              await _chatModel.saveMessage(_toBeSavedMessage);
                          if(result) {
                            _messageController.clear();
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 5),
                              curve: Curves.easeOut,
                            );
                          }

                        }

                      },
                    ),
                  ),
                ],
              ),
            );
  }

  Widget _buildConversationBalloon(Message currentMessage) {

    Color _incomingMessage = Colors.blue;
    Color _outgoingMessage = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatViewModel>(context);

    var _dateTextValue = "";

    var _isMyMessage = currentMessage.isMe;

    try {
      _dateTextValue = _showDate(currentMessage.timestamp ?? Timestamp.now());
    } catch(e) {

    }

    if(_isMyMessage) {

      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _outgoingMessage,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(currentMessage.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_dateTextValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(_chatModel.contactUser.profileURL!),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _incomingMessage,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(4),
                  child: Text(currentMessage.message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Text(_dateTextValue),

            ],
          ),

        ],
      );
    }


  }

  String _showDate(Timestamp timestamp) {
    var _formatter = new DateFormat.Hm();
    var _formattedDate = _formatter.format(timestamp.toDate());
    return _formattedDate;

  }


  void _scrollListener() {
    if(_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadPreviousMessages();
    }
  }

  void loadPreviousMessages() async {

    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);

    if(_isLoading == false) {
      _isLoading = true;
      await _chatModel.loadMoreMessages();
      _isLoading = false;
    }
  }

  _loadingNewMessagesIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child:  CircularProgressIndicator(),
      ),
    );
  }



}
