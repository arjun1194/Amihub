import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/review/review.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FacultyDetail extends StatefulWidget {
  final String facultyCode;
  final String facultyName;

  FacultyDetail({@required this.facultyCode, @required this.facultyName});

  @override
  _FacultyDetailState createState() => _FacultyDetailState();
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _FacultyDetailState extends State<FacultyDetail> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          brightness: Theme.of(context).brightness,
          iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black, //change your color here
          ),
          backgroundColor: blackOrWhite(context),
          title: Text(
            widget.facultyName,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more_vert), onPressed: () => {})
          ],
        ),
        body: FutureBuilder(
          future: amizoneRepository.getFacultyInfo(widget.facultyCode),
          builder: (context, AsyncSnapshot<FacultyInfo> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Loader();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return (snapshot.hasError || snapshot.data == null)
                    ? Padding(
                        child: Scaffold(
                            appBar: CustomAppbar(
                              '',
                              isBackEnabled: true,
                            ),
                            body: ErrorPage(snapshot.error)),
                        padding: EdgeInsets.only(top: 50),
                      )
                    : FacultyDetailBuild(
                        snapshot: snapshot,
                      );
            }
            return Text('end');
          },
        ));
  }
}

class FacultyDetailBuild extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;

  FacultyDetailBuild({Key key, this.snapshot});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ListView(
      children: <Widget>[
        FacultyDetails(snapshot, width),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        ContactActions(facultyInfo: snapshot.data),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        CoursesList(
          snapshot: snapshot,
        ),
        Reviews(contentId: snapshot.data.facultyCode),
      ],
    );
  }
}

class FacultyDetails extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;
  final double width;

  FacultyDetails(this.snapshot, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey[500])
                ]),
                child: Image.network(
                  snapshot.data.facultyImage,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width - 132,
                child: Text(
                  snapshot.data.facultyName,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: width - 132,
                child: Text(
                  snapshot.data.department,
                  style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactActions extends StatefulWidget {
  final FacultyInfo facultyInfo;

  const ContactActions({Key key, this.facultyInfo}) : super(key: key);

  @override
  _ContactActionsState createState() => _ContactActionsState();
}

class _ContactActionsState extends State<ContactActions> {
  TextEditingController _textFieldController = TextEditingController();

  Widget actionButton(String text, IconData iconData, VoidCallback onPressed) {
    return FlatButton(
      shape: CircleBorder(),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.blue,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  _phoneButtonModalSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  subtitle: Text("+918860356201"),
                  trailing: IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () {
                      launchUrl("tel:${widget.facultyInfo.phoneNo}");
                    },
                  ),
                  title: Text("Call"),
                ),
                ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.question_answer),
                    onPressed: () {
                      launchUrl("sms:${widget.facultyInfo.phoneNo}");
                    },
                  ),
                  title: Text("Message"),
                ),
                ListTile(
                  trailing: IconButton(
                    icon: Icon(FontAwesomeIcons.whatsapp),
                    onPressed: () {
                      launchUrl(
                          "https://api.whatsapp.com/send?phone=${widget.facultyInfo.phoneNo}");
                    },
                  ),
                  title: Text("WhatsApp"),
                ),
                _isCorrectCheck("phone number",
                    iconData: Icons.call, textInputType: TextInputType.phone)
              ],
            ),
          );
        });
  }

  Column _isCorrectCheck(String type,
      {IconData iconData, TextInputType textInputType}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Is this correct?"),
            Container(
              height: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OutlineButton(
                    padding: EdgeInsets.all(0),
                    shape: StadiumBorder(),
                    child: Text(
                      "Yes",
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 500)).then((val) {
                        scaffoldKey.currentState.showSnackBar(platformSnackBar(
                            content: Text("Thanks for feedback"),
                            duration: Duration(milliseconds: 1000)));
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlineButton(
                    padding: EdgeInsets.all(0),
                    shape: StadiumBorder(),
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 100)).then((val) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                content: Text("Do you have the correct $type?"),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: new Text(
                                      'No'.toUpperCase(),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                      _correctInfoTextField(
                                          textInputType: textInputType,
                                          iconData: iconData);
                                    },
                                    child: new Text(
                                      'Yes'.toUpperCase(),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ],
                              );
                            });
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  _correctInfoTextField(
      {IconData iconData, TextInputType textInputType, int maxLength}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return _onWillPop(
                  iconData: iconData, textInputType: textInputType);
            },
            child: Container(
              color: getColor(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: getColor())),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: getColor())),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: getColor())),
                  contentPadding: EdgeInsets.only(left: 15),
                  alignLabelWithHint: true,
                  labelText: '',
                  hintText: "What's the correct?",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(iconData),
                  counter: Container(
                    height: 0,
                    width: 0,
                  ),
                ),
                autofocus: true,
                maxLength: iconData == Icons.call ? 10 : null,
                maxLines: null,
                keyboardType: textInputType,
              ),
            ),
          );
        });
  }

  Color getColor() {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff121212)
        : Colors.white;
  }

  _cabinButtonPressed() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('Cabin'),
                  trailing: Text("E1-202"),
                ),
                _isCorrectCheck("cabin",
                    iconData: Icons.place, textInputType: TextInputType.text)
              ],
            ),
          );
        });
  }

  Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        actionButton('Phone', Icons.phone, _phoneButtonModalSheet),
        actionButton('Email', Icons.email, _emailButtonPressed),
        actionButton('Cabin', Icons.place, _cabinButtonPressed),
      ],
    );
  }

  void _emailButtonPressed() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("Email"),
                  subtitle: Text("avirias@live.com"),
                  trailing: IconButton(
                      icon: Icon(Icons.mail_outline),
                      onPressed: () {
                        launchUrl("mailto:${widget.facultyInfo.email}");
                      }),
                ),
                _isCorrectCheck("email",
                    iconData: Icons.email,
                    textInputType: TextInputType.emailAddress)
              ],
            ),
          );
        });
  }

  Future<bool> _onWillPop(
      {IconData iconData, TextInputType textInputType, int maxLength}) {
    if (_textFieldController != null && _textFieldController.text != "") {
      Navigator.pop(context);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: new Text('Discard edit?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _correctInfoTextField(
                        iconData: iconData,
                        textInputType: textInputType,
                        maxLength: maxLength);
                  },
                  child: new Text(
                    'keep writing'.toUpperCase(),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                new FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    _textFieldController.clear();
                    Navigator.of(context).pop(false);
                  },
                  child: new Text('discard'.toUpperCase()),
                ),
              ],
            );
          });
    }
    return Future.value(true);
  }
}

class CoursesList extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;

  CoursesList({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: (this.snapshot.data.courses.length == 0)
          ? Text('')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PageHeader('Courses'),
                SizedBox(
                  height: 4,
                ),
                Wrap(
                  spacing: 5,
                  children: snapshot.data.courses.map((course) {
                    return Chip(label: Text(course.name));
                  }).toList(),
                )
              ],
            ),
    );
  }
}
