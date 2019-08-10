import 'dart:convert';

import 'package:amihub/Components/bottom_navigation_item.dart';
import 'package:amihub/Home/home_appbar.dart';
import 'package:amihub/Home/home_future_builder.dart';
import 'package:amihub/Home/navigation_drawer.dart';
import 'package:amihub/Home/today_class_card.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'ViewModels/today_class_model.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  var jsonData="asd";
  AmizoneRepository amizoneRepository = AmizoneRepository();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
      //@test for getTodayClass()
      int username = 5722381;
  }

  setCurrent(int i) {
    setState(() {
      currentIndex = i;
    });
  }

  List<BottomNavigationBarItem> list = [
    BottomNavItem(
            "Home",
            Icon(
              Icons.home,
            ),
            greenMain,
            "Home")
        .bottomNavItem,
    BottomNavItem(
            "Academics",
            Icon(
              Icons.school,
            ),
            greenMain,
            "Home")
        .bottomNavItem,
    BottomNavItem(
            "Chat",
            Icon(
              Icons.question_answer,
            ),
            greenMain,
            "Home")
        .bottomNavItem,
    BottomNavItem(
            "Profile",
            Icon(
              Icons.person,
            ),
            greenMain,
            "Home")
        .bottomNavItem,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: HomePageDrawer(),
        appBar: HomePageAppbar.getAppBar(() {
          _scaffoldKey.currentState.openDrawer();
        }),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(color: lightGreen),
          currentIndex: currentIndex,
          items: list,
          onTap: (i) {
            setCurrent(i);
          },
          selectedItemColor: Colors.blue,
        ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Todays Classes",style: TextStyle(fontFamily: "Raleway",fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TodayClassBuilder(),
            )
          ],),
      ) ,
    );
  }









}
