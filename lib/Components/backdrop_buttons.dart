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
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: new BoxDecoration(
        border: widget.isSelected
            ? Border(
                bottom: BorderSide(width: 1, color: Colors.lightBlue.shade50))
            : Border.all(color: Color(0xff), width: 0),
      ),
      child: FlatButton(
        onPressed: widget.onPressed,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    widget.iconData,
                    color: Colors.grey.shade200
                        .withOpacity(widget.isSelected ? 1 : 0.5),
                  ),
                  Text(
                    widget.titleText,
                    style: TextStyle(
                        color: Colors.grey.shade200
                            .withOpacity(widget.isSelected ? 1 : 0.5),
                        fontSize: 20.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
