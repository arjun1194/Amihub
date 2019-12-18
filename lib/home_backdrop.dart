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
        child: FutureBuilder(
          future: getPhoto(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Padding(
                  padding: EdgeInsets.all(3),
                  child: IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {
                        accountButtonTapped(snapshot.data);
                      }),
                );
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return IconButton(
                  onPressed: () {
                    accountButtonTapped(snapshot.data);
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blueGrey),
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: snapshot.data != null
                              ? Image.network(snapshot.data,
                                  fit: BoxFit.fitWidth)
                              : Icon(Icons.account_circle)),
                    ),
                  ),
                );
            }
            return Text('end');
          },
        ));
  }

  accountButtonTapped(String photo) async {
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
                  borderRadius: BorderRadius.circular(8)),
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
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                    child: FlatButton(
                      onPressed: () {},
                      shape: StadiumBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.info_outline,
                            size: 23,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'About us',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    });
  }

  Future<String> getPhoto() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('photo');
  }

  @override
  void initState() {
    super.initState();
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
