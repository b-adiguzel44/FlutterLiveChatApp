import 'package:flutter_munasaka/model/user_model.dart';


abstract class AuthBase {

  Future<FUser?> currentUser();
  Future<FUser?> signInAnonymously();
  Future<bool?> signOut();
  Future<FUser?> signInWithGoogle();
  Future<FUser?> signInWithEmailandPassword(String email, String password);
  Future<FUser?> createUserWithEmailandPassword(String email, String password);
}