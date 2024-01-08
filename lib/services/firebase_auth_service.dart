import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_base.dart';

class FirebaseAuthService implements AuthBase {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FUser?> currentUser() async {
    try {
      User user = await _firebaseAuth.currentUser!;
      return _userFromFirebase(user);
    } catch(e) {
      print("Error at currentUser() method at FirebaseAuthService: $e");
    }

    return null;
  }

  FUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return FUser(userID: user.uid, email: user.email);
    }
  }

  @override
  Future<FUser?> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print("Error at signInAnonymously() method at FirebaseAuthService: $e");
    }

    return null;
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      // It'll be always null so keep it in here just in case preventing possible bricks
      // Just in case if you manage to sign in with google, remove null check
      if(_googleSignIn.currentUser != null)
        await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch(e) {
      print("Error at signOut() method at FirebaseAuthService: $e");
      return false;
    }

  }

  @override
  Future<FUser?> signInWithGoogle() async {

    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if(_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      // TODO : For debug purposes
      /*print("Printing google user info");
      print(_googleAuth.accessToken);
      print(_googleAuth.idToken);*/

      if(_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken : _googleAuth.idToken,
              accessToken: _googleAuth.accessToken ));
        User? _user = result.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<FUser?> createUserWithEmailandPassword(String email, String password) async {

      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);

  }

  @override
  Future<FUser?> signInWithEmailandPassword(String email, String password) async {

      UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);

  }


}