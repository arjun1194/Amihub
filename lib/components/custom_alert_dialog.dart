import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  final double elevation;
  final ShapeBorder shape;
  final Widget content;
  final List<Widget> actions;
  final Widget title;

  PlatformAlertDialog(
      {Key key,
      this.elevation,
      this.shape,
      @required this.content,
      @required this.actions,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            content: content,
            actions: actions,
            title: title,
          )
        : AlertDialog(
            title: title,
            content: content,
            actions: actions,
            elevation: elevation,
            shape: shape,
          );
  }
}
