import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class LoginRememberForgot extends StatefulWidget {
  final VoidCallback forgotOnPressed;

  LoginRememberForgot({Key key, this.forgotOnPressed}) : super(key: key);

  @override
  _LoginRememberForgotState createState() => _LoginRememberForgotState();
}

class _LoginRememberForgotState extends State<LoginRememberForgot> {
  bool val = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: val,
              onChanged: (bool value) {
                setState(() {
                  val = value;
                });
              },
            ),
            Expanded(child: Text("Remember me")),
            FlatButton(
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: lightGreen),
              ),
              onPressed: () {
                widget.forgotOnPressed();
              },
            )
          ],
        ),
      ),
    );
  }
}
