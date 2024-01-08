import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {

  final String chatOwner;
  final String chatWith;
  final bool seen;
  Timestamp? creationTimestamp;
  final String lastMessage;
  Timestamp? seenDate;
  String? chattedUserUserName;
  String? chattedUserProfileURL;
  DateTime? lastReadDate;
  String? lastReadDateToString;

  Chat(this.chatOwner, this.chatWith, this.seen, this.creationTimestamp,
      this.lastMessage, this.seenDate);



  Map<String, dynamic> toMap() {
    return {
      "chatOwner": chatOwner,
      "chatWith": chatWith,
      "seen": seen,
      "lastMessage": lastMessage,
      "creation_timestamp": creationTimestamp ?? FieldValue.serverTimestamp(),
      "seenDate": seenDate ?? FieldValue.serverTimestamp(),
    };
  }

  Chat.fromMap(Map<String, dynamic> map) :
        chatOwner = map["chatOwner"],
        chatWith = map["chatWith"],
        seen = map["seen"],
        lastMessage = map["lastMessage"],
        creationTimestamp = map["creation_timestamp"],
        seenDate = map["seenDate"];

  @override
  String toString() {
    return 'Chat{chatOwner: $chatOwner, chatWith: $chatWith, seen: $seen, '
        'creationTimestamp: $creationTimestamp, lastMessage: $lastMessage, '
        'seenDate: $seenDate}';
  }
}