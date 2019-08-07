import 'package:flutter/material.dart';
import 'package:amihub/Theme/theme.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  LoginButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Row(
        children: <Widget>[
          Expanded(
              child: RaisedButton(
            color: lightGreen,
            child: Text(
              " L O G I N ",
              style: buttonTextStyle,
            ),
            onPressed: () {
              onPressed();
            },
          )),
        ],
      ),
    );
  }
}

login(BuildContext context) {}
