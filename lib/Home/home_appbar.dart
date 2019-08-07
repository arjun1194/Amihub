import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';

class HomePageAppbar {
  static getAppBar(VoidCallback onMenuClick) {
    return AppBar(
      leading: FlatButton(
        child: Icon(Icons.menu),
        onPressed: onMenuClick,
      ),
      actions: <Widget>[
        Container(
          height: 32,
          width: 32,
        )
      ],
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
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway"),
            ),
          )
        ],
      ),
    );
  }
}
