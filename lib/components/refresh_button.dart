import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  RefreshButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: isLight(context)
          ? Color(0xff3655B5)
          : Color(0xff364042),
      child: Icon(Icons.refresh,
      color: Colors.white,),
      onPressed: onPressed,
    );
  }
}
