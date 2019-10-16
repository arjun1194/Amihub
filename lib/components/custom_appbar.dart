import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppbar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(),
      ),
      centerTitle: true,
      backgroundColor: Color(0xff171C1F),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.of(context).pop();
        }
      ),

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);
}
