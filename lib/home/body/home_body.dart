import 'dart:ui';

import 'package:amihub/home/body/course/course_detail.dart';
import 'package:amihub/home/body/home/donut_chart.dart';
import 'package:amihub/home/body/home/horizontal_chart.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/components/utilities.dart';
import 'package:amihub/home/body/home/home_future_builder.dart';
import 'package:amihub/models/backdrop_selected.dart';
import 'package:amihub/models/course.dart';
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
                // TODO : Change The Pie Chart
                buildContainer(
                    height, width, scaleFactor, DonutChartFutureBuilder()),
                // TODO : Remove this for 1st semester
                PageHeader("Score Summary"),
                Container(
                    height: height / width < 2.0
                        ? height * 0.31 * scaleFactor
                        : height * 0.31 * scaleFactor,
                    width: width * 0.95,
                    child: HorizontalChartBuilder()),
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

  _todayClassCardModal(TodayClass todayClass) async {
    var backdropSelected = Provider.of<BackdropSelected>(context);
    Course course =
        await amizoneRepository.fetchCourseWithCourseName(todayClass.title);
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
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ), color: Colors.grey.shade300.withOpacity(0.3)),
                              padding: EdgeInsets.all(8),
                              child: Text(double.parse(course.percentage)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                              ),)),
                          Text("Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.grey.shade300.withOpacity(0.3),
                                blurRadius: 10,
                              )
                            ]
                          ),),
                          Container(
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ), color: Colors.grey.shade300.withOpacity(0.3),),
                              padding: EdgeInsets.all(8),
                              child: Text('${course.present}/${course.total}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),)),
                        ],
                      ),
                      SizedBox(height: 15,),
                      listTileElement(
                          title: todayClass.title,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
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
