import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/database/database_helper.dart';
import 'package:amihub/home/body/course/my_course_seamer.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCourseBuilder extends StatefulWidget {
  @override
  _MyCourseBuilderState createState() => _MyCourseBuilderState();
}

class _MyCourseBuilderState extends State<MyCourseBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  String dropdownValue = '';
  Future<List> myFuture;
  static const semesterPadding = 10.0;
  List<String> semesterList;
  int semester = 2;

  setSemester() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      semester = prefs.getInt("semester");
      dropdownValue = semesterList.elementAt(semester - 1);
      myFuture = amizoneRepository.fetchMyCoursesWithSemester(semester);
    });

  }

  @override
  void initState() {
    super.initState();
    semesterList = [
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten'
    ];
    setSemester();
  }

  refresh() {
    DatabaseHelper.db.deleteCourseWithSemester(semester);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PageHeader("My Courses"),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Semester",
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: semesterPadding),
                    child: Material(
                      shape: StadiumBorder(
                          side: BorderSide(
                              width: 1, color: Colors.grey.shade200)),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: dropdownValue,
                          isExpanded: false,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              semester =
                                  semesterList.indexOf(dropdownValue) + 1;

                              myFuture = amizoneRepository
                                  .fetchMyCoursesWithSemester(semester);
                            });
                          },
                          items: semesterList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: CourseFutureBuilder(
                myFuture: myFuture,
              ),
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
    );
  }
}

class CourseBuild extends StatefulWidget {
  final AsyncSnapshot<List<Course>> snapshot;

  CourseBuild({this.snapshot});

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
            var percentage = double.tryParse(
                "${widget.snapshot.data.elementAt(index).percentage}");
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 0,
                    right: 8,
                  ),
                  title: Text(
                    widget.snapshot.data[index].courseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(widget.snapshot.data[index].courseCode),
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
                      Text(
                          "${widget.snapshot.data[index].present}/${widget.snapshot.data[index].total} "),
                      Text("(" + percentage.toStringAsFixed(2) + ")",
                          style: TextStyle(color: Colors.black45))
                    ],
                  ),
                  onTap: () {},
                ),
                Divider(),
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

class CourseError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.cloud_off,
                color: Colors.white,
                size: 50,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[400], shape: BoxShape.circle),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Could not fetch Courses',
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
      ),
    );
  }
}

class CourseFutureBuilder extends StatelessWidget {
  final Future<List> myFuture;

  CourseFutureBuilder({this.myFuture});

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
                ? CourseError()
                : CourseBuild(
                    snapshot: snapshot,
                  );
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
