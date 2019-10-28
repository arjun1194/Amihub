import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageAppbar {
  static getAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Color(0xfffafafa),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/amihub.png',
            height: 32,
            width: 32,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              appTitle,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
