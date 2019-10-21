import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  RefreshButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      child: Icon(Icons.refresh),
      onPressed: onPressed,
    );
  }
}
