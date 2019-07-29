import 'package:amihub/Components/textfield.dart';
import 'package:amihub/Login/login-icon.dart';
import 'package:amihub/Login/login-inputs.dart';
import 'package:amihub/Login/login-text.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/captcha.dart';
import 'package:amihub/unnamed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login/login-button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginInputs inputs;
  MyTextField username;
  MyTextField password;
  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputs = LoginInputs();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    username = MyTextField(
      hintText: "username",
      obscureText: false,
      keyboardType: TextInputType.text,
      textEditingController: usernameController,
    );
    password = MyTextField(
      hintText: "password",
      obscureText: true,
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
    );
  }

  void login(String username,String password){
    var route = MaterialPageRoute(builder: (BuildContext context)=>CaptchaPage(username:username,password: password,));
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(color: Colors.white,
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginIcon(),
            LoginText(),
            LoginInputs(
              username: username,
              password: password,
            ),
            LoginButton(
              onPressed: (){print(usernameController.text);print(passwordController.text);login(usernameController.text,passwordController.text);},
            ),
          ],
        ),
      ),
    ),);
  }
}
