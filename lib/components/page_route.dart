import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CustomPageRoute {
  static Future pushPage({BuildContext context, Widget child}) {
    return Platform.isIOS
        ? Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => child))
        : Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => child));
  }
}
