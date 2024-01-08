import 'package:flutter_munasaka/model/user_model.dart';
import 'auth_base.dart';

class FakeAuthenticationService implements AuthBase {

  String userID = "2131212312312";

  @override
  Future<FUser> currentUser() async {
    return await Future.value(FUser(userID: userID, email: ""));
  }

  @override
  Future<FUser> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2), () =>
        FUser(userID: userID, email: "")
    );
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<FUser> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2), () =>
        FUser(userID: "google_user_id_123456789", email: "google-email")
    );
  }

  @override
  Future<FUser> createUserWithEmailandPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () =>
        FUser(userID: "created_user_id_213121", email: email)
    );
  }

  @override
  Future<FUser> signInWithEmailandPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () =>
        FUser(userID: "logon_user_id_984654", email: email)
    );
  }

}