import 'package:flutter/material.dart';
import 'package:amihub/Components/textfield.dart';

class LoginInputs extends StatelessWidget {
  final MyTextField username = MyTextField("Username",TextInputType.text,false);
  final MyTextField password = MyTextField("Password",TextInputType.text,true);

  String getUsername(){
    return username.getText();

  }

  String getPassword(){
    return password.getText();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      username,
      password,
    ],);
  }
}
