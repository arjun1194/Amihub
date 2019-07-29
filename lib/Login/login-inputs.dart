import 'package:flutter/material.dart';
import 'package:amihub/Components/textfield.dart';

class LoginInputs extends StatelessWidget {
  final MyTextField username;
  final MyTextField password;
  LoginInputs({Key key, this.username,this.password}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      username,
      password,

    ],);
  }
}
