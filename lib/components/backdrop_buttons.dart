import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackDropButton extends StatefulWidget {
  final IconData iconData;
  final String titleText;
  final bool isSelected;
  final VoidCallback onPressed;

  BackDropButton(
      this.iconData, this.titleText, this.isSelected, this.onPressed);

  @override
  _BackDropButtonState createState() => _BackDropButtonState();
}

class _BackDropButtonState extends State<BackDropButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        shape: StadiumBorder(),
        onPressed: widget.onPressed,
        icon: Icon(
          widget.iconData,
          color: Colors.grey.shade200.withOpacity(widget.isSelected ? 1 : 0.5),
        ),
        label: Text(
          widget.titleText,
          style: TextStyle(
            color:
                Colors.grey.shade300.withOpacity(widget.isSelected ? 1 : 0.5),
            fontSize: 18.0,
          ),
        ));
  }
}
