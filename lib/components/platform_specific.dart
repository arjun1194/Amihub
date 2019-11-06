import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CustomPageRoute {
  static Future pushPage(
      {@required BuildContext context, @required Widget child}) {
    return Platform.isIOS
        ? Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => child, maintainState: false))
        : Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => child,
            maintainState: false,
          ));
  }
}

IconData backButton() {
  return Platform.isIOS ? CupertinoIcons.back : Icons.arrow_back;
}
