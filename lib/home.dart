import 'package:amihub/Components/bottom_navigation_item.dart';
import 'package:amihub/Home/home_appbar.dart';
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
    BottomNavItem("", Icon(Icons.home), greenMain, "Home").bottomNavItem,
    BottomNavItem("", Icon(Icons.home), greenMain, "Home").bottomNavItem,
    BottomNavItem("", Icon(Icons.home), greenMain, "Home").bottomNavItem,
  ];

  onMenuClick() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: HomePageAppbar.getAppBar(() {
          _scaffoldKey.currentState.openDrawer();
        }),
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: lightGreen),
          selectedLabelStyle: TextStyle(color: lightGreen),
          currentIndex: currentIndex,
          items: list,
          onTap: (int i) {
            setCurrent(i);
          },
          selectedItemColor: Colors.blue,
        ));
  }
}
