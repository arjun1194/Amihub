import 'package:flutter/material.dart';
import 'package:amihub/Theme/theme.dart';



class LoginIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Hero(
        tag: "Home",
        child: Icon(
          Icons.home,
          color: lightGreen,
          size: 200,
        ),
      ),
    );
  }
}
