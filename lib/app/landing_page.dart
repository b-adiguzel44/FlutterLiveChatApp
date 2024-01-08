import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/sign_in/sign_in_page.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final  _userModel = Provider.of<FUserModel>(context, /*listen: false*/);
    if(_userModel.state == ViewState.Idle) {
      if(_userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userModel.user,);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

  }
}
