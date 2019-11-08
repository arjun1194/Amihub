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
import 'package:amihub/models/backdrop_selected.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final Key key;

  Home({this.key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget selected;
  List<Widget> homeWidgets = [
    HomeBody(),
    HomeTodayClass(),
    HomeMyCourses(),
    MyFaculty(),
    HomeResults(),
    HomeMyProfile(),
    Settings()
  ];

  //info button (i) on the appbar
  Widget iconButton() {
    return IconButton(
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
        });
  }



  @override
  Widget build(BuildContext context) {
    var backdropSelected = Provider.of<BackdropSelected>(context);
    print(backdropSelected.selected);
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
                style:TextStyle(
                  color: Colors.grey.shade200.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ) ,
              ),
            )
          ],
        ),
        backLayerColor:
            isLight(context) ? Color(0xff171C1F) : Color(0xff1a1d1e),
        headerHeight: 40,
        backLayer: Center(child:BackDropButtons()),
        frontLayer: homeWidgets[backdropSelected.selected ?? 0],
        iconPosition: BackdropIconPosition.leading,
        actions: [iconButton()],
      ),
    );
  }
}

class BackDropButtons extends StatefulWidget {
  @override
  _BackDropButtonsState createState() => _BackDropButtonsState();
}

class _BackDropButtonsState extends State<BackDropButtons> {

  @override
  Widget build(BuildContext context) {
    var backdropSelected = Provider.of<BackdropSelected>(context);

    List<String> titles = [
      "home",
      "Today's Class",
      "My Courses",
      'My Faculty',
      "Results",
      "My Profile",
      "Settings"
    ];
    List<IconData> icons = [
      Icons.home,
      Icons.list,
      Icons.library_books,
      Icons.person,
      Icons.home,
      Icons.account_circle,
      Icons.settings
    ];



    List<Widget> backdropButtons = List.generate(
        titles.length,
        (int index) => BackDropButton(
            icons[index],
            titles[index],
            backdropSelected.selected == index,
            (){setState(() {
              Backdrop.of(context).fling();
              backdropSelected.selected = index;
            });}));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: backdropButtons,
    );
  }
}
