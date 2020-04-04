import 'dart:ui';

import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/home/body/course/course_detail.dart';
import 'package:amihub/home/body/home/donut_chart.dart';
import 'package:amihub/home/body/home/horizontal_chart.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/components/utilities.dart';
import 'package:amihub/home/body/home/home_future_builder.dart';
import 'package:amihub/home/body/result/results.dart';
import 'package:amihub/models/backdrop_selected.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/models/course_attendance_type.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/repository/refresh_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  RefreshRepository refreshRepository = RefreshRepository();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  AmizoneRepository amizoneRepository = AmizoneRepository();
  bool _isRefreshing;

  @override
  void initState() {
    super.initState();
    _isRefreshing = false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: isLight(context) ? Colors.white : Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeader("Today's Class"),
          SizedBox(
            height: 4,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 15),
              children: <Widget>[
                buildContainer(
                    height,
                    width,
                    scaleFactor,
                    HomeTodayClassBuilder(
                      onCardTap: _todayClassCardModal,
                    )),
                PageHeader("Attendance Summary"),
                buildContainer(height, width, scaleFactor,
                    DonutChartFutureBuilder(_donutChartModal)),
                // TODO : Remove this for 1st semester
                PageHeader("Score Summary"),
                buildContainer(
                    height,
                    width,
                    scaleFactor,
                    HorizontalChartBuilder(
                      tapped: _horizontalChartBottomSheet,
                    )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: RefreshButton(
          onPressed: !_isRefreshing
              ? () {
                  scaffoldKey.currentState.showSnackBar(platformSnackBar(
                    content: Text('Refreshing'),
                    elevation: 8,
                    duration: Duration(milliseconds: 500),
                  ));
                  refresh();
                }
              : null),
    );
  }

  _donutChartModal(CourseAttendanceType attendanceType) async {
    if (attendanceType != null) {
      String text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int semester = prefs.getInt("semester");
      List<Course> courses =
          await amizoneRepository.fetchMyCoursesWithSemester(semester);
      switch (attendanceType.attendanceType) {
        case "BELOW_75":
          courses.retainWhere((f) => double.parse(f.percentage) < 75.00);
          text = "Below 75";
          break;
        case "BETWEEN_75_TO_85":
          courses.retainWhere((f) =>
              double.parse(f.percentage) >= 75.00 &&
              double.parse(f.percentage) < 85.00);
          text = "75 to 85";
          break;
        case "ABOVE_85":
          courses.retainWhere((f) => double.parse(f.percentage) >= 85.00);
          text = "Above 85";
          break;
      }
      _showDonutChartModal(courses, text);
    }
  }

  void _showDonutChartModal(List<Course> courses, String text) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            elevation: 0,
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                child: Container(
                  decoration: ShapeDecoration(
                    color: isLight(context)
                        ? Colors.grey.shade200.withOpacity(0.5)
                        : Colors.grey.shade800.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 8,
                          child: Opacity(
                            opacity: 0.1,
                            child: Text(
                              '$text',
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                        ListView(
                          physics: BouncingScrollPhysics(),
                          children: courses.map((f) {
                            return Padding(
                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: isLight(context)
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.5),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      right: 50,
                                      bottom: 5,
                                      child: Opacity(
                                        opacity: 0.08,
                                        child: Text('${double.parse(f.percentage)
                                            .toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 25
                                        ),),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(f.courseName),
                                      subtitle: Text("Go to course detail"),
                                      trailing: Icon(Icons.arrow_forward),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(builder: (context) {
                                          return CoursePage(
                                            course: f,
                                          );
                                        }));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  _horizontalChartBottomSheet(Score score) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            elevation: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: isLight(context)
                      ? Colors.grey.shade200.withOpacity(0.5)
                      : Colors.grey.shade800.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 5,
                        right: 40,
                        child: Opacity(
                          opacity: 0.1,
                          child: Text(
                            'Sem ${score.semester.toString()}',
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 0,
                        child: Opacity(
                          opacity: 0.1,
                          child: Text(
                            "CGPA",
                            style: TextStyle(fontSize: 55),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 0,
                        child: Opacity(
                          opacity: 0.1,
                          child: Text(
                            "SGPA",
                            style: TextStyle(fontSize: 55),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    score.cgpa.toString(),
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    score.sgpa.toString(),
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: isLight(context)
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.black.withOpacity(0.5),
                              ),
                              child: ListTile(
                                title: Text("Result"),
                                subtitle: Text("Go to results"),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                            appBar: CustomAppbar("Results"),
                                            body: HomeResults(
                                              score: score,
                                            ),
                                          )));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _todayClassCardModal(TodayClass todayClass) async {
    var backdropSelected = Provider.of<BackdropSelected>(context);
    Course course =
        await amizoneRepository.fetchCourseWithCourseName(todayClass.title);
    String markText = (todayClass.color == "#f00")
        ? "Absent"
        : (todayClass.color == "#4FCC4F") ? "Present" : '';
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            elevation: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
              child: Container(
                decoration: ShapeDecoration(
                  color: isLight(context)
                      ? Colors.grey.shade200.withOpacity(0.5)
                      : Colors.grey.shade800.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Opacity(
                          opacity: 0.1,
                          child: Text(
                            "Attendance",
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.15,
                          child: Text(
                            markText,
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Opacity(
                              opacity: 0.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    '${double.parse(course.percentage).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30),
                                  ),
                                  Text(
                                    '${course.present}/${course.total}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          listTileElement(
                              title: todayClass.title,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    CupertinoPageRoute(builder: (context) {
                                  return CoursePage(
                                    course: course,
                                  );
                                }));
                              },
                              subtitle: "Go to course detail"),
                          SizedBox(
                            height: 8,
                          ),
                          listTileElement(
                              onTap: () {
                                Navigator.pop(context);
                                backdropSelected.selected = 1;
                              },
                              title: "Today",
                              subtitle: "Go to today class")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Container listTileElement(
      {String title, String subtitle, @required VoidCallback onTap}) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: isLight(context)
            ? Colors.white.withOpacity(0.7)
            : Colors.black.withOpacity(0.6),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<Null> refresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await Utility.checkInternet().then((onValue) async {
      await refreshRepository
          .refreshTodayClass(DateFormat("MM/dd/yyyy").format(DateTime.now()))
          .then((val) async {
        await refreshRepository.refreshMetadata().then((val) {
          setState(() {});
          scaffoldKey.currentState.showSnackBar(platformSnackBar(
            content: Text('Updated...'),
            duration: Duration(milliseconds: 500),
          ));
          _isRefreshing = false;
        });
      });
    }).catchError((onError) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String time = sharedPreferences.getString("lastTimeTCUpdated");
      DateTime lastTime = DateTime.parse(time);
      scaffoldKey.currentState.showSnackBar(platformSnackBar(
        content: Text(
          "Can't connect to our server.\nlast updated ${Utility.lastTimeUpdated(lastTime)} ago",
        ),
        duration: Duration(milliseconds: 1200),
      ));
      setState(() {
        _isRefreshing = false;
      });
    });
  }

  Container buildContainer(
      double height, double width, double scaleFactor, Widget child) {
    if (height / width < 2)
      return Container(
          height: 0.3 * height * scaleFactor,
          width: 0.95 * width,
          child: child);
    return Container(
      height: 0.26 * height * scaleFactor,
      width: 0.95 * width,
      child: child,
    );
  }
}
