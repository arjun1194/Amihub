import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/draggable_scrollbar.dart';
import 'package:amihub/components/error.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/todayclass/today_class_builder.dart';
import 'package:amihub/models/attendance.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseAttendanceDetail extends StatefulWidget {
  final Course course;

  const CourseAttendanceDetail({Key key, this.course}) : super(key: key);

  @override
  _CourseAttendanceDetailState createState() => _CourseAttendanceDetailState();
}

class _CourseAttendanceDetailState extends State<CourseAttendanceDetail> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLight(context)
          ? Colors.white
          : Colors.black,
      appBar: CustomAppbar(widget.course.courseName),
      body: FutureBuilder(
        future: amizoneRepository.fetchCourseAttendance(
            courseId: widget.course.courseId),
        builder:
            (BuildContext context, AsyncSnapshot<List<Attendance>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return AttendanceShimmer();
            case ConnectionState.active:
              return Container();
            case ConnectionState.done:
              return (snapshot.hasError || snapshot.data == null)
                  ? ErrorPage()
                  : attendanceBuild(snapshot.data);
              break;
          }
          return Text('end');
        },
      ),
    );
  }


  attendanceBuild(List<Attendance> attendances) {
    ScrollController scrollController = ScrollController();
    return DraggableScrollbar.semicircle(
      controller: scrollController,
      backgroundColor: Colors.blueGrey.shade700,
      labelTextBuilder: (offset) {
        int currentItem = scrollController.hasClients
            ? (scrollController.offset /
                    scrollController.position.maxScrollExtent *
                    attendances.length)
                .floor()
            : 0;
        if (currentItem >= attendances.length)
          currentItem = attendances.length - 1;
        DateTime dateTime = DateFormat('dd/MM/yyyy')
            .parse(attendances.elementAt(currentItem).date);

        return Text(DateFormat.MMMd().format(dateTime),
        style: TextStyle(color: Colors.white),);
      },
      scrollbarTimeToFade: Duration(seconds: 2),
      labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
      heightScrollThumb: 45,
      child: ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          Attendance attendance = attendances.elementAt(index);
          DateTime dateTime = DateFormat('dd/MM/yyyy').parse(attendance.date);
          int total = attendance.present + attendance.absent;
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(
                          side: BorderSide(
                              color: Color(0xffadc0ca), width: 0.5))),
                  child: InkWell(
                    onTap: () {
                      CustomPageRoute.pushPage(
                          context: context,
                          child: Scaffold(
                            appBar: CustomAppbar('Classes'),
                            body: TodayClassBuilder(
                              isHeader: false,
                              date: dateTime,
                            ),
                          ));
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child:
                              Text(DateFormat.yMMMMEEEEd().format(dateTime))),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          side:
                              BorderSide(color: Color(0xffadc0ca), width: 0.5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Attendance ${attendance.present}/$total',
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xffdbdbdf)
                                    : Color(0xff2e4362)),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          attendance.remarks != ""
                              ? Text(
                                  attendance.remarks,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class AttendanceShimmer extends StatefulWidget {
  @override
  _AttendanceShimmerState createState() => _AttendanceShimmerState();
}

class _AttendanceShimmerState extends State<AttendanceShimmer>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController animationController;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    animation = new ColorTween(
      begin: const Color(0xffd6d6d6),
      end: const Color(0xffe8e8e8),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 35,
                    decoration: ShapeDecoration(
                        shape: StadiumBorder(
                            side: BorderSide(
                                color: Color(0xffadc0ca), width: 0.5))),
                    child: Center(
                      child: Container(
                        color: animation.value,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 10,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: double.infinity,
                    height: 34,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          side:
                              BorderSide(color: Color(0xffadc0ca), width: 0.5)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: 9,
                          color: animation.value,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
