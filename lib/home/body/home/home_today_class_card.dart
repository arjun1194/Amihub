import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestWidget extends StatefulWidget {
  final String courseName;
  final String facultyName;
  final String attendanceColor;
  final String roomNo;
  final String courseCode;
  final DateTime start;
  final DateTime end;
  final Color topColor;
  final Color bottomColor;

  TestWidget(
      this.courseName,
      this.facultyName,
      this.attendanceColor,
      this.roomNo,
      this.courseCode,
      this.start,
      this.end,
      this.topColor,
      this.bottomColor);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
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
        elevation: 8,
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
                          Text(
                              "${DateFormat.jm().format(widget.start)} - ${DateFormat.jm().format(widget.end)}",
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
                                              ? "Absent"
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
