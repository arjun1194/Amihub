

import 'package:amihub/components/backdrop.dart';
import 'package:amihub/components/backdrop_buttons.dart';
import 'package:amihub/home/body/home_body.dart';
import 'package:amihub/home/body/my_courses.dart';
import 'package:amihub/home/body/my_profile.dart';
import 'package:amihub/home/body/results.dart';
import 'package:amihub/home/body/todays_classes.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

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
    HomeResults(),
    HomeMyProfile()
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    void changeSelected(int val) {
      setState(() {
        selected = val;
        homeWidget = homeWidgets[selected];
      });
    }

    return BackdropScaffold(
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Row(
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
                    fontFamily: "Raleway",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      backLayerColor: Color(0xff171C1F),
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
        FlatButton(
          child: Text(""),
          onPressed: () {},
        )
      ],
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
        BackDropButton(Icons.home, "Results", widget.selected == 3, () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(3);
          });
        }),
        BackDropButton(Icons.account_circle, "My Profile", widget.selected == 4,
            () {
          setState(() {
            Backdrop.of(context).fling();
            widget.changeSelected(4);
          });
        }),
      ],
    );
  }
}
