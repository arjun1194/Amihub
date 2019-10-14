import 'package:flutter/material.dart';



class BottomNavItem {
   String text;
   Icon icon;
   Color activeIconColor;
   String activeIconText;
   BottomNavigationBarItem bottomNavItem;
   BottomNavItem(String text,Icon icon,Color activeIconColor,String activeIconText)
   {

       this.text = text;
       this.icon = icon;
       this.activeIconText = activeIconText;
       this.bottomNavItem = BottomNavigationBarItem(title:Text(text,style: TextStyle(color: Colors.black54),),icon: icon  );

  }


}