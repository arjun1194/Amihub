import 'dart:ui';

import 'package:amihub/components/backdrop.dart';
import 'package:amihub/components/backdrop_buttons.dart';
import 'package:amihub/components/logout.dart';
import 'package:amihub/home/body/faculty/faculty.dart';
import 'package:amihub/home/body/home_body.dart';
import 'package:amihub/home/body/my_courses.dart';
import 'package:amihub/home/body/results.dart';
import 'package:amihub/home/body/settings/settings.dart';
import 'package:amihub/home/body/todays_classes.dart';
import 'package:amihub/models/backdrop_selected.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Key key;

  Home({this.key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget selected;
  String photo;
  List<Widget> homeWidgets = [
    HomeBody(),
    HomeTodayClass(),
    HomeMyCourses(),
    MyFaculty(),
    HomeResults(),
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

  Widget accountButton() {
    return Material(
      shape: CircleBorder(),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: photo != null
          ? IconButton(
              onPressed: accountButtonTapped,
              icon: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueGrey),
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(photo, fit: BoxFit.fitWidth)),
                ),
              ),
            )
          : Icon(Icons.person_outline),
    );
  }

  accountButtonTapped() async {
    String name;
    String enrollNo;
    SharedPreferences.getInstance().then((val) {
      name = val.getString("name");
      enrollNo = val.getString('enrollNo');
    }).then((val) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('Logged in as'),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              contentPadding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(photo, fit: BoxFit.cover)),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(enrollNo),
                  trailing: IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        logoutDialog(context);
                      }),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: OutlineButton(
                    child: Text('Add another account'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {},
                  ),
                )
              ],
            );
          });
    });
  }


  Future<SharedPreferences> openSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  @override
  void initState() {
    super.initState();
    openSharedPref().then((val) {
      photo = val.getString('photo');
    });
  }

  @override
  Widget build(BuildContext context) {
    var backdropSelected = Provider.of<BackdropSelected>(context);
    return BackdropScaffold(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/amihub.png',
            height: 32,
            width: 32,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            appTitle,
            style: TextStyle(
              color: Colors.grey.shade200.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      backLayerColor: isLight(context) ? Color(0xff171C1F) : Color(0xff1a1d1e),
      headerHeight: 40,
      backLayer: Center(child: BackDropButtons()),
      frontLayer: homeWidgets[backdropSelected.selected ?? 0],
      iconPosition: BackdropIconPosition.leading,
      actions: [accountButton()],
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
      "Home",
      "Today's Class",
      "My Courses",
      'My Faculty',
      "Results",
      "Settings"
    ];
    List<IconData> icons = [
      Icons.home,
      Icons.list,
      Icons.library_books,
      Icons.person,
      Icons.home,
      Icons.settings
    ];

    List<Widget> backdropButtons = List.generate(
        titles.length,
        (int index) => BackDropButton(
                icons[index], titles[index], backdropSelected.selected == index,
                () {
              setState(() {
                Backdrop.of(context).fling();
                backdropSelected.selected = index;
              });
            }));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: backdropButtons,
    );
  }
}
