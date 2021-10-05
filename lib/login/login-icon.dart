import 'package:flutter/material.dart';

class LoginIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
            width: 200, height: 200, child: Image.asset("assets/logo.png")));
  }
}
