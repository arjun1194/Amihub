import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackDropButton extends StatefulWidget {
  final IconData iconData;
  final String titleText;
  bool isSelected;
  final VoidCallback onPressed;

  BackDropButton(
      this.iconData, this.titleText, this.isSelected, this.onPressed);

  @override
  _BackDropButtonState createState() => _BackDropButtonState();
}

class _BackDropButtonState extends State<BackDropButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: StadiumBorder(),
      onPressed: widget.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            widget.iconData,
            color:
                Colors.grey.shade200.withOpacity(widget.isSelected ? 1 : 0.5),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            widget.titleText,
            style: TextStyle(
              color:
                  Colors.grey.shade300.withOpacity(widget.isSelected ? 1 : 0.5),
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );
  }
}
