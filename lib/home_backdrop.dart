import 'dart:ui';

import 'package:amihub/components/backdrop.dart';
import 'package:amihub/components/backdrop_buttons.dart';
import 'package:amihub/home/body/faculty/faculty.dart';
import 'package:amihub/home/body/home_body.dart';
import 'package:amihub/home/body/my_courses.dart';
import 'package:amihub/home/body/my_profile.dart';
import 'package:amihub/home/body/results.dart';
import 'package:amihub/home/body/settings/settings.dart';
import 'package:amihub/home/body/todays_classes.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selected;
  Widget homeWidget;
  List<Widget> homeWidgets = [
    HomeBody(),
    HomeTodayClass(),
    HomeMyCourses(),
    MyFaculty(),
    HomeResults(),
    HomeMyProfile(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    void changeSelected(int val) {
      setState(() {
        selected = val;
        homeWidget = homeWidgets[selected];
      });
    }

    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: BackdropScaffold(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/amihub.png',
              height: 32,
              width: 32,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                appTitle,
                style: TextStyle(
                  color: Colors.grey.shade200.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        backLayerColor: Theme.of(context).brightness == Brightness.light
            ? Color(0xff171C1F)
            : Color(0xff1a1d1e),
        headerHeight: 40,
        backLayer: Center(
          child: BackDropButtons(
            selected: selected,
            changeSelected: changeSelected,
          ),
        ),
        frontLayer: homeWidget,
        iconPosition: BackdropIconPosition.leading,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      var width = MediaQuery.of(context).size.width;
                      return Center(
                          child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: width * 0.8,
                            height: width * 0.6,
                            decoration: new BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text('Under \nDevelopment',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.display2),
                            ),
                          ),
                        ),
                      ));
                    });
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selected = 0;
    homeWidget = HomeBody();
    AmizoneRepository amizoneRepository = AmizoneRepository();
    amizoneRepository.fetchTodayClass();
  }
}

class BackDropButtons extends StatefulWidget {
  int selected;
  final Key key;
  Function(int) changeSelected;

  BackDropButtons({this.key, this.selected, this.changeSelected})
      : super(key: key);

  @override
  _BackDropButtonsState createState() => _BackDropButtonsState();
}

class _BackDropButtonsState extends State<BackDropButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BackDropButton(Icons.home, "Home", widget.selected == 0, () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(0);
          });
        }),
        BackDropButton(Icons.list, "Today's Class", widget.selected == 1, () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(1);
          });
        }),
        BackDropButton(Icons.library_books, "My Courses", widget.selected == 2,
            () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(2);
          });
        }),
        BackDropButton(Icons.library_books, "My Faculty", widget.selected == 3,
            () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(3);
          });
        }),
        BackDropButton(Icons.home, "Results", widget.selected == 4, () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(4);
          });
        }),
        BackDropButton(Icons.account_circle, "My Profile", widget.selected == 5,
            () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(5);
          });
        }),
        BackDropButton(Icons.settings, "Settings", widget.selected == 6, () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(6);
          });
        })
      ],
    );
  }
}
