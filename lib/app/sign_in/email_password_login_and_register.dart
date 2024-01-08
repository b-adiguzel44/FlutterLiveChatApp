import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_munasaka/app/error_exceptions.dart';
import 'package:flutter_munasaka/common_widget/platform_specific_alert_dialog.dart';
import 'package:flutter_munasaka/common_widget/social_login_in_button.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

enum FormType { LOGIN, REGISTER }

class EmailAndPasswordLoginPage extends StatefulWidget {
  const EmailAndPasswordLoginPage({super.key});

  @override
  State<EmailAndPasswordLoginPage> createState() =>
      _EmailAndPasswordLoginPageState();
}

class _EmailAndPasswordLoginPageState extends State<EmailAndPasswordLoginPage> {
  String _email = "", _password = "";
  late String _buttonText, _linkText;
  var _formType = FormType.LOGIN;

  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState?.save();
    debugPrint("Email : $_email, Password : $_password");
    final _userModel = Provider.of<FUserModel>(context, listen: false);

    if (_formType == FormType.LOGIN) {
      try {
        FUser? _logonUser =
        await _userModel.signInWithEmailandPassword(_email, _password);
        if (_logonUser != null) {
          debugPrint("Oturum açan user id : ${_logonUser.userID}");
        }
      } on FirebaseAuthException catch(e) {
        PlatformSpecificAlertDialog(
          label: "Oturum açma hatası",
          description: OccuredExceptions.show(e.code),
          mainButtonLabel: "Tamam",
        ).show(context);
      }
    } else {
      try {
        FUser? _createdUser =
        await _userModel.createUserWithEmailandPassword(_email, _password);
        if (_createdUser != null) {
          debugPrint("Oturum açan user id : ${_createdUser.userID}");
        }
      } on FirebaseAuthException catch(e) {
            PlatformSpecificAlertDialog(
            label: "Kullanıcı oluşturma hata",
            description: OccuredExceptions.show(e.code),
            mainButtonLabel: "Tamam",
          ).show(context);
      }
      catch(e) {
        debugPrint("GENERAL CATCH - Widget create-account error handled \n: $e");
      }
    }
  }

  void _changeNames() {
    setState(() {
      _formType =
          _formType == FormType.LOGIN ? FormType.REGISTER : FormType.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LOGIN ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LOGIN
        ? "Hesabınız yok mu? Kayıt Olun"
        : "Hesabınız var mı? Giriş Yapın";

    final _userModel = Provider.of<FUserModel>(context);

    if(_userModel.user != null) {
      Future.delayed(Duration(milliseconds:  10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giriş / Kayıt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _userModel.emailErrorMessage != null
                              ? _userModel.emailErrorMessage
                              : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: "E-mail",
                          labelText: "E-mail",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String? value) {
                          if (value != null) _email = value;
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: _userModel.passwordErrorMessage != null
                              ? _userModel.passwordErrorMessage
                              : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Şifre",
                          labelText: "Şifre",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String? value) {
                          if (value != null) _password = value;
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      SocialLoginButton(
                        buttonText: _buttonText,
                        buttonBackColor: Theme.of(context).primaryColor,
                        buttonForeColor: Colors.grey,
                        radius: 10.0,
                        onPressed: () => _formSubmit(),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextButton(
                        onPressed: () => _changeNames(),
                        child: Text(_linkText),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}