import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/sign_in/email_password_login_and_register.dart';
import 'package:flutter_munasaka/common_widget/social_login_in_button.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {


  Future<void> _signWithGoogle(BuildContext context) async {
    final  _userModel = Provider.of<FUserModel>(context, listen: false);
    FUser? _user = await _userModel.signInWithGoogle();
    print("Logon as a google user id : ${_user?.userID}");
  }

  void _signInWithEmailandPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailAndPasswordLoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Münaşaka',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            SocialLoginButton(
              buttonText: "Gmail ile Oturum Açın",
              textColor: Colors.black,
              buttonIcon: Image.asset("images/gmail_icon.png"),
              buttonBackColor: Colors.white,
              buttonForeColor: Colors.grey,
              onPressed: () => _signWithGoogle(context),
            ),
            SocialLoginButton(
              onPressed: () => _signInWithEmailandPassword(context),
              buttonText: "E-mail ve Şifre ile Oturum Açın",
              buttonIcon: Icon(
                Icons.email,
                color: Colors.white,
                size: 32,
              ),
            ),
          ]
        ),
      ),
    );
  }



}