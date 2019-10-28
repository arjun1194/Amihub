import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/course/course_attendance_detail.dart';
import 'package:amihub/models/course.dart';
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
  AmizoneRepository amizoneRepository = AmizoneRepository();

  int semester;

  getSemester() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    semester = prefs.getInt("semester");
  }

  @override
  void initState() {
    super.initState();
    getSemester().then((val) {
      setState(() {});
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
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        elevation: 0,
        brightness: Theme.of(context).brightness,
        leading: IconButton(
          icon: Icon(
            backButton(),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 35),
                  )),
                  OutlineButton(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300
                    ),
                    child: Text('Attendance detail',
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),),
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
            PageHeader('Faculties'),
            fetchFaculty()
          ],
        ),
      ),
    );
  }

  Widget fetchFaculty() {
    return FutureBuilder(
      future: amizoneRepository.fetchMyFaculty(),
      builder: (context, AsyncSnapshot<List<Faculty>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return facultyShimmer();
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            List<Faculty> faculties = snapshot.data
                .where(
                    (faculty) => faculty.courseName == widget.course.courseName)
                .toList();
            return (snapshot.hasError || snapshot.data == null)
                ? Text('error')
                : Container(
                    height: 140,
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: faculties.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Faculty faculty = faculties.elementAt(index);
                        return faculty.facultyImage != null
                            ? Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              faculty.facultyImage,
                                            ),
                                            radius: 50,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: 150,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          decoration: ShapeDecoration(
                                              shape: StadiumBorder(),
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.blueGrey.shade800
                                                  : Colors.white),
                                          child: Text(
                                            faculty.facultyName,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: blackOrWhite(context)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                  );
        }
        return Text('end');
      },
    );
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

  facultyShimmer() {
    return Container(
      height: 130,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey, width: 0.5)),
            child: Container(
              width: 180,
              child: Center(
                child: Text('dsadsadasd'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Faculty {
  String courseCode;
  String courseName;
  String facultyImage;
  String facultyName;
  String facultySignature;

  Faculty({
    this.courseCode,
    this.courseName,
    this.facultyImage,
    this.facultyName,
    this.facultySignature,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        courseCode: json["courseCode"],
        courseName: json["courseName"],
        facultyImage: json["facultyImage"],
        facultyName: json["facultyName"],
        facultySignature: json["facultySignature"],
      );

  Map<String, dynamic> toJson() => {
        "courseCode": courseCode,
        "courseName": courseName,
        "facultyImage": facultyImage,
        "facultyName": facultyName,
        "facultySignature": facultySignature,
      };

  @override
  String toString() {
    return 'Faculty{courseCode: $courseCode, courseName: $courseName, facultyImage: $facultyImage, facultyName: $facultyName, facultySignature: $facultySignature}';
  }
}
