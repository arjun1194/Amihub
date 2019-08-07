import 'package:amihub/Components/textfield.dart';
import 'package:amihub/Login/login-icon.dart';
import 'package:amihub/Login/login-inputs.dart';
import 'package:amihub/Login/login-remember-forgot.dart';
import 'package:amihub/Login/login-text.dart';
import 'package:amihub/ViewModels/login_model.dart';
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

  void login(LoginModel loginModel) {
    if (username != null && password != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/captcha', (Route<dynamic> route) => false,
          arguments: loginModel);
    }
  }

  void forgotPassword() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/Forgot', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
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
            LoginRememberForgot(
              forgotOnPressed: forgotPassword,
            ),
            LoginButton(
              onPressed: () {
                LoginModel loginModel = LoginModel(
                    usernameController.text, passwordController.text);
                login(loginModel);
              },
            ),
          ],
        ),
      ),
    );
  }
}
