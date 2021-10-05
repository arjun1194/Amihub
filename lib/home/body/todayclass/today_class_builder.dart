import 'dart:async';
import 'dart:ui';

import 'package:amihub/components/error.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/components/utilities.dart';
import 'package:amihub/home/body/todayclass/today_class_seamer.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/repository/refresh_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayClassBuilder extends StatefulWidget {
  final DateTime date;

  final bool isHeader;

  TodayClassBuilder({this.date, this.isHeader});

  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  RefreshRepository refreshRepository = RefreshRepository();
  final key = new GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  DateTime selectDate;

  @override
  void initState() {
    super.initState();
    selectDate = widget.date == null ? DateTime.now() : widget.date;
  }

  changeState(changedDate) {
    setState(() {
      selectDate = changedDate;
    });
  }

  Future<Null> refresh() async {
    await Utility.checkInternet().then((onValue) async {
      await refreshRepository
          .refreshTodayClass(DateFormat("MM/dd/yyyy").format(selectDate))
          .then((val) {
        setState(() {});
        key.currentState.showSnackBar(platformSnackBar(
          content: Text('Updated...'),
          duration: Duration(milliseconds: 500),
        ));
      });
    }).catchError((onError) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String time = sharedPreferences.getString("lastTimeTCUpdated");
      DateTime lastTime = DateTime.parse(time);
      key.currentState.showSnackBar(platformSnackBar(
        content: Text(
          "Can't connect to our server.\nlast updated ${Utility.lastTimeUpdated(lastTime)} ago",
        ),
        duration: Duration(milliseconds: 1200),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      key: refreshKey,
      displacement: 75,
      child: Scaffold(
        key: key,
        body: Container(
          color: isLight(context) ? Colors.white : Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.isHeader ? PageHeader("Classes") : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Opacity(
                    opacity: 0.7,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      color: isLight(context) ? Colors.black : Colors.white,
                      onPressed: () {
                        changeState(selectDate.subtract(Duration(days: 1)));
                      },
                    ),
                  ),
                  OutlineButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            backgroundColor:
                                isLight(context) ? Colors.white : Colors.black,
                            itemStyle: TextStyle(
                                fontFamily: "OpenSans",
                                fontSize: 19,
                                color: isLight(context)
                                    ? Colors.black
                                    : Colors.white),
                            cancelStyle: TextStyle(
                                fontFamily: "OpenSans",
                                fontSize: 17,
                                color: Colors.red),
                            doneStyle:
                                TextStyle(fontFamily: "OpenSans", fontSize: 17),
                          ),
                          showTitleActions: true,
                          minTime: DateTime.now().subtract(Duration(days: 200)),
                          maxTime: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day)
                              .add(Duration(days: 30)), onConfirm: (date) {
                        setState(() {
                          selectDate = date;
                        });
                        changeState(selectDate);
                      }, currentTime: selectDate, locale: LocaleType.en);
                    },
                    child: Text(
                      dateFormat(selectDate),
                      style:
                          TextStyle(color: Colors.blue.shade700, fontSize: 15),
                    ),
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowRight),
                      color: isLight(context) ? Colors.black : Colors.white,
                      onPressed: () {
                        changeState(selectDate.add(Duration(days: 1)));
                      },
                    ),
                  ),
                ],
              ),
              !isSameDay(DateTime.now(), selectDate)
                  ? Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Center(
                        child: OutlineButton(
                          shape: StadiumBorder(),
                          child: Text("Back to today"),
                          onPressed: () {
                            changeState(DateTime.now());
                          },
                        ),
                      ),
                    )
                  : Container(),
              Expanded(child: buildFutureBuilder())
            ],
          ),
        ),
        floatingActionButton: RefreshButton(
          onPressed: () {
            refreshKey.currentState?.show(atTop: true);
          },
        ),
      ),
    );
  }

  FutureBuilder<List> buildFutureBuilder() {
    String date = DateFormat("MM/dd/yyyy").format(selectDate);
    return FutureBuilder<List<TodayClass>>(
      future: amizoneRepository.fetchTodayClassWithDate(date, date),
      builder:
          (BuildContext context, AsyncSnapshot<List<TodayClass>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return isLight(context)
                ? TodayClassShimmer(
                    colorTween: ColorTween(
                        begin: Colors.grey.shade200, end: Colors.grey.shade400),
                  )
                : TodayClassShimmer(
                    colorTween: ColorTween(
                        begin: Colors.grey.shade900, end: Color(0xff121212)),
                  );
          case ConnectionState.done:
            if (snapshot.hasError) return ErrorPage(snapshot.error);
            // No Class check
            if (snapshot.data.length == 1 &&
                snapshot.data.elementAt(0).title == "") return NoClassToday();
            return Container(
                child: TodayClassBuild(
              todayClasses: snapshot.data,
            ));
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(''); // unreachable
      },
    );
  }
}

class NoClassToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Image.asset(
          "assets/chill.png",
          width: width * 0.5,
          height: width * 0.5,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'All caught up!',
          style: TextStyle(
            fontSize: 35,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Sit back,Relax! \nYou have no classes today',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        Expanded(child: Container())
      ],
    );
  }
}

class TodayClassBuild extends StatefulWidget {
  final List<TodayClass> todayClasses;

  TodayClassBuild({this.todayClasses});

  @override
  _TodayClassBuildState createState() => _TodayClassBuildState();
}

class _TodayClassBuildState extends State<TodayClassBuild> {
  List<TodayClass> todayClass = [];

  @override
  void initState() {
    super.initState();
    todayClass = widget.todayClasses;
    todayClass.removeWhere((f) => f.title == "");
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 8),
        itemCount: todayClass.length,
        itemBuilder: (context, index) {
          TodayClass todayClass = this.todayClass.elementAt(index);
          DateTime end = Jiffy(todayClass.end, "MM/dd/yyyy h:mm:ss a").dateTime;
          DateTime start =
              Jiffy(todayClass.start, "MM/dd/yyyy h:mm:ss a").dateTime;
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onLongPress: () {
                        todayClassBottomSheet(todayClass);
                      },
                      title: Text(
                        todayClass.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              '${DateFormat("hh:mm").format(start)} - ${DateFormat("hh:mm").format(end)}'),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(todayClass.roomNo),
                          )
                        ],
                      ),
                      leading: Container(
                        color: (todayClass.color == "#f00")
                            ? Colors.red
                            : (todayClass.color == "#4FCC4F")
                                ? Colors.green
                                : Colors.transparent,
                        width: 8,
                      ),
                      contentPadding: EdgeInsets.only(left: 0, right: 8),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                        color: Colors.grey.shade600.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  todayClassBottomSheet(TodayClass todayClass) {
    String markText = (todayClass.color == "#f00")
        ? "Absent"
        : (todayClass.color == "#4FCC4F") ? "Present" : '';
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          List<String> faculties = todayClass.facultyName.split(",");
          DateTime end = Jiffy(todayClass.end, "MM/dd/yyyy h:mm:ss a").dateTime;
          DateTime start =
              Jiffy(todayClass.start, "MM/dd/yyyy h:mm:ss a").dateTime;
          return Material(
            color: Colors.transparent,
            elevation: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: ShapeDecoration(
                  color: isLight(context)
                      ? Colors.grey.shade200.withOpacity(0.5)
                      : Colors.grey.shade800.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.55,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Opacity(
                        opacity: 0.1,
                        child: Text(
                          markText,
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                    ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        stack(
                          Text(
                            "Course",
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            todayClass.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        stack(
                          Text(
                            "Time",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            '${DateFormat.jm().format(start)} to ${DateFormat.jm().format(end)}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        stack(
                          Text('Date',
                              style: TextStyle(
                                fontSize: 30,
                              )),
                          Text(
                            '${DateFormat.yMMMMEEEEd().format(start)}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        stack(
                          Text("Room no",
                              style: TextStyle(
                                fontSize: 30,
                              )),
                          Text(
                            todayClass.roomNo,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        stack(
                          Text("Code",
                              style: TextStyle(
                                fontSize: 30,
                              )),
                          Text(
                            todayClass.courseCode,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        stack(
                          Text(
                            faculties.length == 1 ? "Faculty" : "Faculties",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            faculties.join("\n"),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Stack stack(Text text2, Text text1) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Opacity(opacity: 0.6, child: text1)),
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Opacity(opacity: 0.2, child: text2)),
      ],
    );
  }
}

String dateFormat(DateTime time) {
  var todayDate = DateTime.now();
  if (isSameDay(todayDate, time.add(Duration(days: 1))))
    return 'Yesterday, ${DateFormat.MMMd("en_US").format(time)}';
  else if (isSameDay(time, todayDate.add(Duration(days: 1))))
    return 'Tomorrow, ${DateFormat.MMMd("en_US").format(time)}';
  else if (isSameDay(time, todayDate))
    return 'Today, ${DateFormat.MMMd("en_US").format(time)}';
  return '${DateFormat('EEEE, MMM d').format(time)}';
}

bool isSameDay(DateTime time1, DateTime time2) {
  return (time1.day == time2.day &&
          time1.month == time2.month &&
          time1.year == time2.year)
      ? true
      : false;
}
