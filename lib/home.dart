import 'package:amihub/Components/bottom_navigation_item.dart';
import 'package:amihub/Home/home_appbar.dart';
import 'package:amihub/Home/navigation_drawer.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  //LoadViewModel loadViewModel = ModalRoute.of(context).settings.arguments;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
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

  onMenuClick() {}

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
        ));
  }
}
