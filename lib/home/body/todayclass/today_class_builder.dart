import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/database/database_helper.dart';
import 'package:amihub/home/body/todayclass/today_class_seamer.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TodayClassBuilder extends StatefulWidget {
  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  DateTime selectDate;

  @override
  void initState() {
    super.initState();
    selectDate = DateTime.now();
  }

  changeState(changedDate) {
    setState(() {
      selectDate = changedDate;
    });
  }

  refresh() {
    setState(() {});
    return DatabaseHelper.db.deleteTodayClassesWithDate(
        "${selectDate.month}/${selectDate.day}/${selectDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PageHeader("Classes"),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 20,
                    color: Colors.grey.shade700,
                    onPressed: () {
                      changeState(selectDate.subtract(Duration(days: 1)));
                    },
                  ),
                  FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 3, 5),
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
                    icon: Icon(Icons.arrow_forward_ios),
                    iconSize: 20,
                    color: Colors.grey.shade700,
                    onPressed: () {
                      changeState(selectDate.add(Duration(days: 1)));
                    },
                  ),
                ],
              ),
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
        Positioned(
          right: height * 0.03,
          bottom: height * 0.03,
          child: RefreshButton(
            onPressed: refresh,
          ),
        )
      ],
    );
  }

  FutureBuilder<List> buildFutureBuilder() {
    return FutureBuilder<List<TodayClass>>(
      future: amizoneRepository.fetchTodayClassWithDate(
          "${selectDate.month}/${selectDate.day}/${selectDate.year}",
          "${selectDate.month}/${selectDate.day}/${selectDate.year}"),
      builder:
          (BuildContext context, AsyncSnapshot<List<TodayClass>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return TodayClassShimmer();
          case ConnectionState.done:
            if (snapshot.hasError) return TodayClassError();
            // No Class check
            if (snapshot.data.elementAt(0).title == "") return NoClassToday();
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

class TodayClassError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Icon(
              Icons.cloud_off,
              color: Colors.white,
              size: 50,
            ),
            decoration:
                BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Could not fetch Class',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Please Check Your internet and try again',
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}

class NoClassToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: width * 0.1,
          ),
          Container(
            child: Center(
              child: Icon(
                Icons.assignment_turned_in,
                color: Colors.white,
                size: 60,
              ),
            ),
            height: width * 0.3,
            width: width * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'All caught up!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Sit back,Relax! You have no classes today',
          ),
          Expanded(child: Container())
        ],
      ),
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
      physics: BouncingScrollPhysics(),
      children: List.generate(widget.snapshot.data.length, (int index) {
        TodayClass todayClass = widget.snapshot.data.elementAt(index);
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
                widget.snapshot.data[index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      '${DateFormat.Hm().format(start)} - ${DateFormat.Hm().format(end)}'),
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
            Divider(),
          ],
        );
      }),
    );
  }

  todayClassBottomSheet(TodayClass todayClass) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          List<String> faculties = todayClass.facultyName.split(",");
          DateTime end =
              DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.end);
          DateTime start =
              DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.start);
          return Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Scrollbar(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                  children: <Widget>[
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
              ));
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
  return '${DateFormat.yMMMMEEEEd("en_US").format(time)}';
}

bool isSameDay(DateTime time1, DateTime time2) {
  return (time1.day == time2.day &&
          time1.month == time2.month &&
          time1.year == time2.year)
      ? true
      : false;
}