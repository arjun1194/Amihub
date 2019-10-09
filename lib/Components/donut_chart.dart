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
            return DonutChartSeamer();
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

class DonutChartSeamer extends StatelessWidget {
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
        colorFn: (CourseAttendance courseAttendance, _) {
          if (courseAttendance.attendance > 85)
            return charts.Color.fromHex(code: grey);
          else if (courseAttendance.attendance > 75 &&
              courseAttendance.attendance <= 85)
            return charts.Color.fromHex(code: grey);
          else
            return charts.Color.fromHex(code: grey);
        },
        data: [CourseAttendance("", 100)],
      )
    ];
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 0.35 * height,
        width: 0.95 * width,
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
              child: DonutChart(seriesList: series, animate: true),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ChartAnnotations(
                  "Above 75",
                  Color(0xffafafaf),
                  textColor: Colors.grey,
                ),
                ChartAnnotations(
                  "75 to 85",
                  Color(0xffafafaf),
                  textColor: Colors.grey,
                ),
                ChartAnnotations(
                  "Below 75",
                  Color(0xffafafaf),
                  textColor: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//     ""

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
        domainFn: (CourseAttendance courseAttendance, _) =>
            courseAttendance.courseName,
        measureFn: (CourseAttendance courseAttendance, _) =>
            courseAttendance.attendance,
        colorFn: (CourseAttendance courseAttendance, _) {
          if (courseAttendance.attendance > 85)
            return charts.Color.fromHex(code: color1);
          else if (courseAttendance.attendance > 75 &&
              courseAttendance.attendance <= 85)
            return charts.Color.fromHex(code: color2);
          else
            return charts.Color.fromHex(code: color3);
        },
        data: courses,
      )
    ];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 0.35 * height,
        width: 0.95 * width,
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
              child: DonutChart(seriesList: series, animate: true),
            ),
            Column(
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
                        color: Colors.lightBlue,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
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
    return Container(
      child: charts.PieChart(seriesList,
          animate: animate,
          defaultRenderer: new charts.ArcRendererConfig(arcWidth: 40)),
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
            width: 16,
            height: 16,
            color: color,
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
