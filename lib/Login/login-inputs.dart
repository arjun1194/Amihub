import 'package:flutter/material.dart';
import 'package:amihub/Components/textfield.dart';

//TODO:remove this widget and add it in Components without hardCoding
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
