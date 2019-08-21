import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  final String courseName;
  final String facultyName;
  final int attendanceState;
  final String roomNo;
  final String courseCode;
  final String startTime;
  final String endTime;
  final Color topColor;
  final Color bottomColor;

  TestWidget(
      this.courseName,
      this.facultyName,
      this.attendanceState,
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

    print("--------------------------->>" + height.toString());
    print("--------------------------->>" + width.toString());

    return Center(
        child: Stack(
      children: <Widget>[
        Container(
            height: 250,
            width: 0.9 * width,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6.0,
                    // has the effect of softening the shadow
                    spreadRadius: 1.0,
                    // has the effect of extending the shadow
                    offset: Offset(
                      3.0, // horizontal, move right 10
                      1.0, // vertical, move down 10
                    ),
                  )
                ],
                gradient: LinearGradient(
                    colors: [widget.topColor, widget.bottomColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Stack(
              children: <Widget>[
                QuarterCircle(
                  circleAlignment: CircleAlignment.topRight,
                  color: Colors.white.withOpacity(0.1),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.courseName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    widget.facultyName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                widget.attendanceState == 0
                                    ? ""
                                    : widget.attendanceState == 1
                                        ? "Present"
                                        : widget.attendanceState == 2
                                            ? "absent"
                                            : "error",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.account_balance,
                              color: Colors.white,
                            ),
                            Text(
                              widget.roomNo,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                            Text(
                              widget.courseCode,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            Text(
                              "complete",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ],
    ));
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
