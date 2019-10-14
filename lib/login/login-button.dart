import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  LoginButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("LOGIN",),
          color: Colors.blueGrey[400],
          splashColor: Colors.blueGrey[200],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)),
          textColor: Colors.white,
          highlightElevation: 5.0,
          elevation: 7.0,
          onPressed: () {},
        ),
      ],
    );
  }
}

login(BuildContext context) {}
