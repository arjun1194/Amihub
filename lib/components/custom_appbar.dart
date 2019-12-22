import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCenter;
  final bool isBackEnabled;

  CustomAppbar(this.title,{this.isBackEnabled = true,this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: isCenter,
      brightness: Theme.of(context).brightness,
      title: Text(
        title,
        maxLines: 2,
        style: TextStyle(
            color: isLight(context)
                ? Colors.black
                : Colors.white),
      ),
      backgroundColor: blackOrWhite(context),
      elevation: 0,
      leading: isBackEnabled ? IconButton(
          icon: Icon(backButton()),
          color: isLight(context)
              ? Colors.black
              : Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          }) : Container()
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);
}
