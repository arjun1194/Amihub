import 'package:amihub/Models/course_attendance.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonutChartFutureBuilder extends StatefulWidget {
  @override
  _DonutChartFutureBuilderState createState() =>
      _DonutChartFutureBuilderState();
}

class _DonutChartFutureBuilderState extends State<DonutChartFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AmizoneRepository().fetchcurrentAttendance(),
      // a previously-obtained Future<String> or null
      builder: (BuildContext context,
          AsyncSnapshot<List<CourseAttendance>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return DonutChartShimmer();
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return DonutChartBuild(
                snapshot.data, "#56CD93", "#ECA24D", "#FF5479");
        }
        return Text(''); // unreachable
      },
    );
  }
}

class DonutChartShimmer extends StatefulWidget {
  @override
  _DonutChartShimmerState createState() => _DonutChartShimmerState();
}

class _DonutChartShimmerState extends State<DonutChartShimmer>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController animationController;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    animation = new ColorTween(
      begin: Colors.grey.shade200,
      end: Colors.grey.shade400,
    ).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String grey = "#afafaf";

    var series = [
      charts.Series<CourseAttendance, dynamic>(
        id: 'attendance',
        domainFn: (CourseAttendance courseAttendance, _) =>
            courseAttendance.courseName,
        measureFn: (CourseAttendance courseAttendance, _) =>
            courseAttendance.attendance,
        colorFn: (CourseAttendance courseAttendance, _) =>
            charts.ColorUtil.fromDartColor(animation.value),
        data: [
          CourseAttendance(" ", 100),
          CourseAttendance("  ", 100),
          CourseAttendance("   ", 200)
        ],
      )
    ];
    return Padding(
      padding: EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        shadowColor: Color(0xffd6d6d6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white70, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 0.35 * height,
                  width: 0.6 * width,
                  child: DonutChart(seriesList: series, animate: false),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ChartAnnotations(
                        "Above 75",
                        animation.value,
                        textColor: Colors.grey,
                      ),
                      ChartAnnotations(
                        "75 to 85",
                        animation.value,
                        textColor: Colors.grey,
                      ),
                      ChartAnnotations(
                        "Below 75",
                        animation.value,
                        textColor: Colors.grey,
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
  }
}

class DonutChartBuild extends StatelessWidget {
  final List<CourseAttendance> courses;
  final String color1;
  final String color2;
  final String color3;

  DonutChartBuild(this.courses, this.color1, this.color2, this.color3);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var series = [
      charts.Series<CourseAttendance, dynamic>(
        id: 'attendance',
        displayName: "sdsdd",
        domainFn: (CourseAttendance courseAttendance, _) =>
            courseAttendance.courseName,
        labelAccessorFn: (CourseAttendance courseAttendance, _) {
          if (courseAttendance.attendance.round() != 0)
            return '${courseAttendance.attendance.round()}';
          else
            return "";
        },
        measureFn: (CourseAttendance courseAttendance, _) =>
            courseAttendance.attendance,
        colorFn: (CourseAttendance courseAttendance, _) {
          if (courseAttendance.courseName == "2")
            return charts.Color.fromHex(code: color1);
          else if (courseAttendance.courseName == "1")
            return charts.Color.fromHex(code: color2);
          else
            return charts.Color.fromHex(code: color3);
        },
        data: courses,
      )
    ];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        shadowColor: Color(0xffd6d6d6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 0.35 * height,
                  width: 0.6 * width,
                  child: DonutChart(
                    seriesList: series,
                    animate: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ChartAnnotations("Above 85", Color(0xff56CD93)),
                      ChartAnnotations("75 to 85", Color(0xffECA24D)),
                      ChartAnnotations("Below 75", Color(0xffFF5479)),
                      FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Text(
                              "SEE ALL",
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.lightBlue,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutChart({Key key, @required this.seriesList, @required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      animationDuration: Duration(milliseconds: 500),
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 40,
          strokeWidthPx: 3,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]),
    );
  }
}

class ChartAnnotations extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  ChartAnnotations(this.text, this.color, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            width: 16,
            height: 16,
          ),
        ),
        Text(
          text,
          style:
              TextStyle(color: (textColor != null) ? textColor : Colors.black),
        ),
      ],
    );
  }
}