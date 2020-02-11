import 'dart:convert';
import 'dart:io';

import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/review.dart';
import 'package:amihub/models/review.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyDetail extends StatefulWidget {
  final String facultyCode;
  final String facultyName;

  FacultyDetail({@required this.facultyCode, @required this.facultyName});

  @override
  _FacultyDetailState createState() => _FacultyDetailState();
}

class _FacultyDetailState extends State<FacultyDetail> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black, //change your color here
          ),
          backgroundColor: blackOrWhite(context),
          title: Text(widget.facultyName),
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
        ContactActions(),
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

class ContactActions extends StatelessWidget {
  Widget actionButton(text, iconData, onPressed) {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        actionButton('Phone', Icons.phone, () {}),
        actionButton('Email', Icons.email, () {}),
        actionButton('Cabin', Icons.place, () {}),
      ],
    );
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

