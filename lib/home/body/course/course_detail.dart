import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/course/course_attendance_detail.dart';
import 'package:amihub/home/body/faculty/faculty_detail.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/models/course_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursePage extends StatefulWidget {
  final Course course;

  const CoursePage({Key key, this.course}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int semester;
  bool isLoading = true;

  getSemester() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("semester");
  }

  @override
  void initState() {
    super.initState();
    // Check here if error comes
    getSemester().then((val) {
      setState(() {
        semester = val;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackOrWhite(context),
      appBar: AppBar(
        backgroundColor: blackOrWhite(context),
        title: Text(
          widget.course.courseName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              TextStyle(color: isLight(context) ? Colors.black : Colors.white),
        ),
        elevation: 0,
        brightness: Theme.of(context).brightness,
        leading: IconButton(
          icon: Icon(
            backButton(),
            color: isLight(context) ? Colors.black : Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                      child: Text(
                    getPercentage(),
                    style: TextStyle(
                        color: isLight(context) ? Colors.black : Colors.white,
                        fontSize: 35),
                  )),
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    child: Text(
                      'Attendance detail',
                      style: TextStyle(
                          color:
                              isLight(context) ? Colors.black : Colors.white),
                    ),
                    onPressed: semester == widget.course.semester
                        ? () {
                            CustomPageRoute.pushPage(
                                context: context,
                                child: CourseAttendanceDetail(
                                    course: widget.course));
                          }
                        : null,
                    shape: StadiumBorder(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            internalAssessmentBuild(),
            isLoading
                ? Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Loader(),
                  )
                : CourseInformation(course: widget.course)
          ],
        ),
      ),
    );
  }

  Widget internalAssessmentBuild() {
    return widget.course.internalAssessment != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: ExpansionTile(
              title: Text('Internal Assessment'),
              trailing: Text(widget.course.internalAssessment.split("[")[0]),
              leading: Icon(Icons.assignment),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.course.internalAssessment,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  Color getColor() {
    var percentage = double.tryParse("${widget.course.percentage}");
    return percentage < 75.00
        ? Colors.red
        : (percentage >= 75.00 && percentage < 85.00)
            ? Colors.yellow
            : Colors.green;
  }

  String getPercentage() {
    var percentage = double.tryParse("${widget.course.percentage}");
    return '${percentage.toStringAsFixed(2)}%';
  }
}

class CourseInformation extends StatelessWidget {
  final Course course;
  final AmizoneRepository amizoneRepository = AmizoneRepository();

  CourseInformation({Key key, this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: amizoneRepository.getCourseInfo(course.courseCode),
      builder: (context, AsyncSnapshot<CourseInfo> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Padding(
              padding: EdgeInsets.only(top: 40),
              child: Loader(),
            );
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData)
              return (snapshot.hasError || snapshot.data == null)
                  ? Padding(
                      child: ErrorPage(),
                      padding: EdgeInsets.only(top: 50),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PageHeader('Faculties'),
                        Container(
                          height: 140,
                          child: ListView.builder(
                            padding: EdgeInsets.all(8),
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.faculties.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              Faculty faculty =
                                  snapshot.data.faculties.elementAt(index);
                              return faculty.photo != null
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 25),
                                                child: InkWell(
                                                  onTap: () {
                                                    CustomPageRoute.pushPage(
                                                        context: context,
                                                        child: FacultyDetail(
                                                            facultyCode: faculty.code,
                                                            facultyName: faculty.name));
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      faculty.photo,
                                                    ),
                                                    radius: 50,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  Alignment.bottomCenter,
                                              child: Container(
                                                width: 150,
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                decoration: ShapeDecoration(
                                                    shape: StadiumBorder(),
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colors
                                                            .blueGrey.shade800
                                                        : Colors.white),
                                                child: Text(
                                                  faculty.name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: blackOrWhite(
                                                          context)),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ),

                        //TODO: add these

                        /**

                      Average assessment
                      course level
                      no of backs
                      average gpa
                      no of students studied
                      semester
                      syllabus
                      course type

                   */
                      ],
                    );
        }
        return Text('end');
      },
    );
  }
}
