import 'dart:convert';

import 'package:amihub/Components/bottom_navigation_item.dart';
import 'package:amihub/Home/home_appbar.dart';
import 'package:amihub/Home/home_future_builder.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Home/Body/home_body.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  var jsonData = "asd";
  Widget currentWidget;
  AmizoneRepository amizoneRepository = AmizoneRepository();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();



  @override
  void initState() {
    super.initState();
    currentWidget = HomeBody();
  }

  setCurrent(int i) {
    setState(() {
      currentIndex = i;
      switch (currentIndex) {
        case 0:
          currentWidget = HomeBody();
          break;
        case 1:
          break; // add academics
        case 2:
          break; //add message
        case 3:
          break; //add profile
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: HomePageAppbar.getAppBar(),
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
        body: BodyWidget(currentWidget));
  }
}

class BodyWidget extends StatefulWidget {
  final Widget widget;

  BodyWidget(this.widget);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.widget;
  }
}
