import 'package:amihub/Components/appbar.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myAppbar,
      body: Column(children: <Widget>[
        SizedBox(child: Image.asset('assets/dog1.jpg'),width: 0.6*width, height:0.3*height,)
      ],),
    );
  }
}
