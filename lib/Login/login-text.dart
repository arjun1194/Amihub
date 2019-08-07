import 'package:flutter/material.dart';
import 'package:amihub/Theme/theme.dart';

//TODO:( Title text )add it in Components without hardCoding

class LoginText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        "Login",
        style: headingStyle,
      ),
    );
  }
}
