import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class FUser {

  final String userID;
  String? email;
  String? userName;
  String? profileURL = "https://cdn.discordapp.com/attachments/136173506474803200/1191700076385533992/image.png?ex=65a6642e&is=6593ef2e&hm=85053a20ed09bd5cd451ac302b5d21a506c8cbfb6d54efa53423c1f9fdbfe3f9&";
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  FUser({required this.userID, required this.email});

  Map<String, dynamic> toMap() {

    return {
      "userID": userID,
      "email": email,
      "userName": userName ??
          email!.substring(0 , email!.indexOf('@')) + generateRandomNumber(),
      "profileURL": profileURL ??
          'https://lh3.googleusercontent.com/a/ACg8ocKboRdN_Gq159g2eAveeqb0p0zAmi9IhG0zQTgs_D02tLY=s288-c-no',
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "level": level ?? 1,
    };

  }

  FUser.fromMap(Map<String, dynamic> map) :
        userID = map["userID"],
        email = map["email"],
        userName = map["userName"],
        profileURL = map["profileURL"],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map["level"];

  FUser.idAndProfileURL({required this.userID, required this.profileURL});

  @override
  String toString() {
    return 'FUser{userID: $userID, email: $email, '
        'userName: $userName, profileURL: $profileURL, '
        'createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String generateRandomNumber() {

    int randomNumber =  Random().nextInt(99999);
    return randomNumber.toString();

  }

}