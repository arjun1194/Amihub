import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String name;

  PageHeader(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 0),
      child: Text(
        name,
        style: TextStyle(fontSize: 18),
      ),
    );
    ;
  }
}
