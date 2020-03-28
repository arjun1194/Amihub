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
import 'package:intl/intl.dart';
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
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20,
                    color: isLight(context)
                        ? Colors.grey.shade700
                        : Colors.white70,
                    onPressed: () {
                      changeState(selectDate.subtract(Duration(days: 1)));
                    },
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
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 20,
                    color: isLight(context)
                        ? Colors.grey.shade700
                        : Colors.white70,
                    onPressed: () {
                      changeState(selectDate.add(Duration(days: 1)));
                    },
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
            if (snapshot.data.length == 1 && snapshot.data.elementAt(0).title == "") return NoClassToday();
            return Container(
                child: TodayClassBuild(
              snapshot: snapshot,
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
  final AsyncSnapshot<List<TodayClass>> snapshot;

  TodayClassBuild({this.snapshot});

  @override
  _TodayClassBuildState createState() => _TodayClassBuildState();
}

class _TodayClassBuildState extends State<TodayClassBuild> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 8, right: 8),
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(widget.snapshot.data.length, (int index) {
        TodayClass todayClass = widget.snapshot.data.elementAt(index);
        if(todayClass.title == "")
          return Container();
        DateTime end =
            DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.end);
        DateTime start =
            DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.start);
        return Column(
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
        );
      }),
    );
  }

  todayClassBottomSheet(TodayClass todayClass) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          List<String> faculties = todayClass.facultyName.split(",");
          DateTime end =
              DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.end);
          DateTime start =
              DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.start);
          return Material(
            color: Colors.transparent,
            elevation: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
              child: Container(
                decoration: ShapeDecoration(
                  color: isLight(context)? Colors.grey.shade200.withOpacity(0.5) : Colors.grey.shade800.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    stack(
                      Text(
                        "Course",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      Text(
                        todayClass.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    stack(
                      Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${DateFormat.jm().format(start)} to ${DateFormat.jm().format(end)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    stack(
                      Text('Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          )),
                      Text(
                        '${DateFormat.yMMMMEEEEd().format(start)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    stack(
                      Text("Room no",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          )),
                      Text(
                        todayClass.roomNo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    stack(
                      Text("Code",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          )),
                      Text(
                        todayClass.courseCode,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
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
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        faculties.join("\n"),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    )
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
          padding: const EdgeInsets.only(left: 10, top: 18),
          child: Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xff474c5d)),
            child: Padding(
                padding: EdgeInsets.fromLTRB(18, 20, 18, 18), child: text1),
          ),
        ),
        Container(
          decoration:
              ShapeDecoration(shape: StadiumBorder(), color: Color(0xff696b60)),
          child: Padding(padding: EdgeInsets.all(8.0), child: text2),
        ),
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
