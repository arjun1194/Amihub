import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/course/my_courses_future_builder.dart';
import 'package:amihub/models/course_attendance.dart';
import 'package:amihub/models/course_attendance_type.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class DonutChartFutureBuilder extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AmizoneRepository().fetchCurrentAttendance(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CourseAttendanceType>> snapshot) {
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
      begin: Colors.grey.shade100,
      end: Colors.grey.shade700,
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
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            decoration: ShapeDecoration(
                color: blackOrWhite(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    side: BorderSide(
                      width: 0.3,
                      color: Colors.grey.shade400,
                    ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 0.35 * height,
                  width: 0.6 * width,
                  color: blackOrWhite(context),
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
                      ),
                      ChartAnnotations(
                        "75 to 85",
                        animation.value,
                      ),
                      ChartAnnotations(
                        "Below 75",
                        animation.value,
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
  final List<CourseAttendanceType> courses;
  final String color1;
  final String color2;
  final String color3;

  DonutChartBuild(this.courses, this.color1, this.color2, this.color3);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var series = [
      charts.Series<CourseAttendanceType, dynamic>(
        id: 'attendance',
        displayName: "sdsdd",
        domainFn: (CourseAttendanceType courseAttendance, _) =>
            courseAttendance.attendanceType,
        labelAccessorFn: (CourseAttendanceType courseAttendance, _) {
          if (courseAttendance.noOfCourses.round() != 0)
            return '${courseAttendance.noOfCourses.round()}';
          else
            return "";
        },
        measureFn: (CourseAttendanceType courseAttendance, _) =>
            courseAttendance.noOfCourses,
        colorFn: (CourseAttendanceType courseAttendance, _) {
          if (courseAttendance.attendanceType == "ABOVE_85")
            return charts.Color.fromHex(code: color1);
          else if (courseAttendance.attendanceType == "BETWEEN_75_TO_85")
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
        shadowColor: Colors.grey,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: ShapeDecoration(
                color: blackOrWhite(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    side: BorderSide(
                      width: 0.3,
                      color: Colors.grey.shade400,
                    ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 0.35 * height,
                  width: 0.55 * width,
                  child: DonutChart(
                    seriesList: series,
                    animate: true,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ChartAnnotations("Above 85", Color(0xff56CD93)),
                        ChartAnnotations("75 to 85", Color(0xffECA24D)),
                        ChartAnnotations("Below 75", Color(0xffFF5479)),
                      ],
                    ),
                    OutlineButton(
                      onPressed: () {
                        CustomPageRoute.pushPage(
                            context: context,
                            child: Scaffold(
                                body: MyCourseBuilder(
                                  isHeader: false,
                                ),
                                appBar: CustomAppbar('My Courses')));
                      },
                      shape: StadiumBorder(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "SEE ALL",
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey.shade600
                                    : Colors.white),
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
    var width = MediaQuery.of(context).size.width;
    return charts.PieChart(
      seriesList,
      animate: animate,
      animationDuration: Duration(milliseconds: 500),
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: width >= 350 ? 40 : 30,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]),
    );
  }
}

class ChartAnnotations extends StatelessWidget {
  final String text;
  final Color color;

  ChartAnnotations(this.text, this.color);

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
        Text(text),
      ],
    );
  }
}
