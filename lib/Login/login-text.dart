import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';



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
