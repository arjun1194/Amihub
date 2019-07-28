import 'package:flutter/material.dart';


class CaptchaPage extends StatefulWidget {
  final  String username;
  final String password;

  CaptchaPage({Key key,this.username, this.password}):super(key:key);

  @override
  _CaptchaPageState createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(color: Colors.lightGreen,width:double.infinity,child: Center(child: Text('Username= ${widget.username} \n Password = ${widget.password}'),),)));
  }
}
