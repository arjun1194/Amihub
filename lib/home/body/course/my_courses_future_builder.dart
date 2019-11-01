import 'package:amihub/components/error.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/database/database_helper.dart';
import 'package:amihub/home/body/course/course_detail.dart';
import 'package:amihub/home/body/course/my_course_seamer.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCourseBuilder extends StatefulWidget {
  final bool isHeader;

  const MyCourseBuilder({Key key, this.isHeader}) : super(key: key);

  @override
  _MyCourseBuilderState createState() => _MyCourseBuilderState();
}

class _MyCourseBuilderState extends State<MyCourseBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  String dropdownValue = '';
  Future<List> myFuture;
  static const semesterPadding = 10.0;
  int userSemester;
  int semester = 2;
  bool isLoading = true;

  setSemester() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    semester = userSemester = prefs.getInt("semester");
    dropdownValue = semesterList.elementAt(semester - 1);
    myFuture = amizoneRepository.fetchMyCoursesWithSemester(semester);
  }

  @override
  void initState() {
    super.initState();
    setSemester().then((val) {
      setState(() {
        isLoading = false;
      });
    });
  }

  refresh() {
    DatabaseHelper.db.deleteCourseWithSemester(semester).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.isHeader ? PageHeader("My Courses") : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Center(
                          child: Material(
                            shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1, color: Colors.grey.shade200)),
                            elevation: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              color: blackOrWhite(context),
                              child: DropdownButton<String>(
                                underline: Container(),
                                value: dropdownValue,
                                isExpanded: false,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    semester = semesterList
                                            .indexOf(dropdownValue) +
                                        1;

                                    myFuture = amizoneRepository
                                        .fetchMyCoursesWithSemester(
                                            semester);
                                  });
                                },
                                items: semesterList
                                    .sublist(0, userSemester)
                                    .map<DropdownMenuItem<String>>(
                                        ( value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: CourseFutureBuilder(
                            myFuture: myFuture, semester: semester),
                      ),
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
              ),
      ),
    );
  }
}

class CourseBuild extends StatefulWidget {
  final AsyncSnapshot<List<Course>> snapshot;

  final int semester;

  CourseBuild({this.snapshot, this.semester});

  @override
  _CourseBuildState createState() => _CourseBuildState();
}

class _CourseBuildState extends State<CourseBuild> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        children: List<Widget>.generate(
          widget.snapshot.data.length,
          (int index) {
            Course course = widget.snapshot.data.elementAt(index);
            var percentage = double.tryParse("${course.percentage}");
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 0,
                    right: 5,
                  ),
                  title: Text(
                    course.courseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(course.courseCode),
                  leading: Container(
                    color: (percentage < 75.00)
                        ? Colors.red
                        : (percentage >= 75.00 && percentage < 85.00)
                            ? Colors.yellow
                            : Colors.green,
                    width: 8,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${course.present}/${course.total} "),
                      !percentage.isNaN
                          ? Text("(" + percentage.toStringAsFixed(2) + ")",
                              style: TextStyle(fontSize: 12))
                          : Text('')
                    ],
                  ),
                  onTap: () {
                    CustomPageRoute.pushPage(
                        context: context, child: CoursePage(course: course));
                  },
                ),
                Divider(
                  color: Colors.grey.shade600.withOpacity(0.4),
                ),
                (index == widget.snapshot.data.length - 1)
                    ? Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: Text("Tap a Course for more details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))))
                    : Container()
              ],
            );
          },
        ));
  }
}

class CourseFutureBuilder extends StatelessWidget {
  final Future<List> myFuture;

  final int semester;

  CourseFutureBuilder({this.myFuture, this.semester});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return MyCourseShimmer();
          case ConnectionState.done:
            return (snapshot.hasError || snapshot.data == null)
                ? ErrorPage()
                : CourseBuild(snapshot: snapshot, semester: semester);
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }
}
