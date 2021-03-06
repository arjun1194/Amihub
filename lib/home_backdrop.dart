import 'dart:io';
import 'dart:ui';
import 'package:amihub/components/about_us.dart';
import 'package:amihub/components/backdrop.dart';
import 'package:amihub/components/backdrop_buttons.dart';
import 'package:amihub/components/logout.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/faculty/faculty.dart';
import 'package:amihub/home/body/home_body.dart';
import 'package:amihub/home/body/course/my_courses.dart';
import 'package:amihub/home/body/result/results.dart';
import 'package:amihub/home/body/settings/settings.dart';
import 'package:amihub/home/body/todayclass/todays_classes.dart';
import 'package:amihub/models/backdrop_selected.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final Key key;

  Home({this.key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String imageData;
  bool dataLoaded = false;
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
        child: IconButton(
          onPressed: () {
            accountButtonTapped();
          },
          icon: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: dataLoaded
                      ? Image.file(File(imageData), fit: BoxFit.fitWidth)
                      : Icon(
                          Icons.account_circle,
                          color: Colors.blueGrey.shade700,
                        )),
            ),
          ),
        ));
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
                  borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.file(
                          File(imageData),
                          fit: BoxFit.cover,
                        )),
                  ),
                  title: Text(
                    name,
                    maxLines: 2,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
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
                  height: 4,
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              CustomPageRoute.pushPage(
                                  context: context, child: AboutUS());
                            },
                            shape: StadiumBorder(),
                            icon: Icon(
                              Icons.info_outline,
                            ),
                            label: Text(
                              'About us',
                            )),
                        FlatButton.icon(
                            shape: StadiumBorder(),
                            onPressed: () {
                              launchUrl(
                                  "https://www.instagram.com/amihubofficial");
                            },
                            icon: Icon(FontAwesomeIcons.instagram),
                            label: Text("Follow"))
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
    });
  }

  Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<int> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('username');
  }

  _downloadImage() async {
    int username = await getUsername();

    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/$username.png';

    File(filePathAndName).exists().then((value) async {
      if (value) {
        setState(() {
          imageData = filePathAndName;
          dataLoaded = true;
        });
      } else {
        var url = userImage(username);
        var response = await http.get(url);
        await Directory(firstPath).create(recursive: true);
        File file2 = new File(filePathAndName);
        file2.writeAsBytesSync(response.bodyBytes);
        setState(() {
          imageData = filePathAndName;
          dataLoaded = true;
        });
      }
    }).catchError((err) {
      print("error Occured");
    });
  }

  @override
  void initState() {
    super.initState();
    _downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    var backdropSelected = Provider.of<BackdropSelected>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BackdropScaffold(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/amihub.png',
              height: 27,
              width: 27,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              appTitle,
              style: TextStyle(
                color: Colors.grey.shade200.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        backLayerColor:
            isLight(context) ? Color(0xff171C1F) : Color(0xff1a1d1e),
        headerHeight: Platform.isIOS ? 45 : 40,
        backLayer: Center(child: BackDropButtons()),
        frontLayer: homeWidgets[backdropSelected.selected ?? 0],
        iconPosition: BackdropIconPosition.leading,
        actions: [accountButton()],
        frontLayerBorderRadius: Platform.isIOS
            ? BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))
            : BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    var backdropSelected = Provider.of<BackdropSelected>(context);

    if (backdropSelected.selected != 0) {
      setState(() {
        backdropSelected.selected = 0;
      });
      return null;
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: new Text('Are you sure?'),
            content: new Text('App will be closed'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              new FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          );
        },
      );
    }
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
      Icons.group,
      Icons.assessment,
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
