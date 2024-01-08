import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String senderId;
  final String receiverId;
  final bool isMe;
  final String message;
  Timestamp? timestamp;


  Message({required this.senderId, required this.receiverId,
    required this.isMe, required this.message});


  Map<String, dynamic> toMap() {
      return {
        "senderId": senderId,
        "receiverId": receiverId,
        "isMe": isMe,
        "message": message,
        "timestamp": timestamp ?? FieldValue.serverTimestamp(),
      };
  }

  Message.fromMap(Map<String, dynamic> map) :
        senderId = map["senderId"],
        receiverId = map["receiverId"],
        isMe = map["isMe"],
        message = map["message"],
        timestamp = map["timestamp"];

  @override
  String toString() {
    return 'Message{senderId: $senderId, receiverId: $receiverId, '
        'isMe: $isMe, message: $message, timestamp: $timestamp}';
  }

}