import 'package:amihub/Login/login-icon.dart';
import 'package:amihub/Login/login-inputs.dart';
import 'package:amihub/Login/login-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'captcha.dart';
import 'Login/login-button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  LoginInputs inputs = LoginInputs();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LoginIcon(),
          LoginText(),
          LoginInputs(),
          LoginButton(onPressed:login,),

        ],
      ),
    ));
  }

login(){
    String username  = inputs.getUsername();
    String password = inputs.getPassword();
    var route = MaterialPageRoute(builder: (BuildContext context)=>CaptchaPage(username:username ,password:password ,),);
    Navigator.push(context, route);
}
}
