import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppbar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context).brightness,
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
      ),
      backgroundColor: blackOrWhite(context),
      elevation: 0,
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          }),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);
}
