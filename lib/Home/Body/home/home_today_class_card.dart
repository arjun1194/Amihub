import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  final String courseName;
  final String facultyName;
  final String attendanceColor;
  final String roomNo;
  final String courseCode;
  final String startTime;
  final String endTime;
  final Color topColor;
  final Color bottomColor;

  TestWidget(this.courseName,
      this.facultyName,
      this.attendanceColor,
      this.roomNo,
      this.courseCode,
      this.startTime,
      this.endTime,
      this.topColor,
      this.bottomColor);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var startHour = int.tryParse(widget.startTime
        .substring(widget.startTime.length - 11, widget.startTime.length - 9));
    var startMinute = int.tryParse(widget.startTime
        .substring(widget.startTime.length - 8, widget.startTime.length - 6));
    var startDate = DateTime
        .now()
        .day;
    var startDateTime = DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month,
        startDate, startHour, startMinute);

    var endHour = int.tryParse(widget.endTime
        .substring(widget.endTime.length - 11, widget.endTime.length - 9));
    var endMinute = int.tryParse(widget.endTime
        .substring(widget.endTime.length - 8, widget.endTime.length - 6));
    var endDate = int.tryParse(widget.endTime.substring(2, 4));
    var endDateTime = DateTime
        .now()
        .day;
    int attendanceState = 1;
    (widget.attendanceColor == "#4FCC4F")
        ? attendanceState = 1
        : (widget.attendanceColor == "#f00")
        ? attendanceState = 2
        : attendanceState = 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Material(
        shadowColor: widget.topColor,
        elevation: 10,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [widget.topColor, widget.bottomColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(13))),
            child: Stack(
              children: <Widget>[
                QuarterCircle(
                  circleAlignment: CircleAlignment.topRight,
                  color: Colors.white.withOpacity(0.1),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.courseName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.person_add_solid,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.facultyName,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.95)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(
                            width: 5,
                          ),
//                              (DateTime.now().isAfter(endDateTime))? Text("Class Completed",style: TextStyle(color: Colors.white),) :
                          Text("$startHour:$startMinute - $endHour:$endMinute",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_balance,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                widget.roomNo,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.description,
                                size: 28,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                widget.courseCode,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              (attendanceState == 1)
                                  ? Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 28,
                              )
                                  : (attendanceState == 2)
                                  ? Icon(
                                Icons.block,
                                color: Colors.white,
                                size: 28,
                              )
                                  : Icon(Icons.home,
                                  color: Colors.transparent),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  (attendanceState == 0)
                                      ? ""
                                      : (attendanceState == 1)
                                      ? "Present"
                                      : (attendanceState == 2)
                                      ? "absent"
                                      : "error",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: attendanceState == 2
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

enum CircleAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class QuarterCircle extends StatelessWidget {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCircle({
    this.color = Colors.grey,
    this.circleAlignment = CircleAlignment.topRight,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRect(
        child: CustomPaint(
          painter: QuarterCirclePainter(
            circleAlignment: circleAlignment,
            color: color,
          ),
        ),
      ),
    );
  }
}

class QuarterCirclePainter extends CustomPainter {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCirclePainter({this.circleAlignment, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height, size.width);
    final offset = circleAlignment == CircleAlignment.topLeft
        ? Offset(.0, .0)
        : circleAlignment == CircleAlignment.topRight
        ? Offset(size.width, .0)
        : circleAlignment == CircleAlignment.bottomLeft
        ? Offset(.0, size.height)
        : Offset(size.width, size.height);
    canvas.drawCircle(offset, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(QuarterCirclePainter oldDelegate) {
    return color == oldDelegate.color &&
        circleAlignment == oldDelegate.circleAlignment;
  }
}
