import 'dart:ui';

import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/home/body/course/course_detail.dart';
import 'package:amihub/home/body/faculty/faculty_detail.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/models/faculty.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class MyFaculty extends StatelessWidget {
  final AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isLight(context) ? Colors.white : Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          PageHeader('My Faculty'),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: FutureBuilder(
              future: amizoneRepository.fetchMyFaculty(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Faculty>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return FacultyShimmer();
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    return (snapshot.hasError || snapshot.data == null)
                        ? ErrorPage(snapshot.error)
                        : FacultyBuild(faculties: snapshot.data);
                }
                return Text('end');
              },
            ),
          )
        ],
      ),
    );
  }
}

class FacultyBuild extends StatelessWidget {
  final List<Faculty> faculties;

  const FacultyBuild({Key key, @required this.faculties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      itemCount: faculties.length,
      itemBuilder: (context, index) {
        Faculty faculty = faculties.elementAt(index);
        return Container(
          child: faculty.facultyImage != null
              ? Container(
                  height: 110,
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          faculty.facultyImage,
                        ),
                        radius: 40,
                      ),
                      Positioned(
                        top: 70,
                        left: 70,
                        child: InkWell(
                          onTap: () {
                            CustomPageRoute.pushPage(
                                context: context,
                                child: FacultyDetail(
                                  facultyCode: faculty.facultyCode,
                                  facultyName: faculty.facultyName,
                                ));
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: StadiumBorder(),
                                color: isLight(context)
                                    ? Color(0xffe6f8f9)
                                    : Color(0xff3c3d47)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(faculty.facultyName),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 105,
                        child: InkWell(
                          onTap: () async {
                            AmizoneRepository amizoneRepo = AmizoneRepository();
                            Course course = await amizoneRepo
                                .fetchCourseWithCourseName(faculty.courseName);
                            CustomPageRoute.pushPage(
                                context: context,
                                child: CoursePage(
                                  course: course,
                                ));
                          },
                          child: Container(
                            width: 200,
                            decoration: ShapeDecoration(
                              shape: StadiumBorder(),
                              color: Color(0xff35495e),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                faculty.courseName,
                                maxLines: 1,
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Divider(),
                      )
                    ],
                  ),
                )
              : Container(),
        );
      },
    );
  }
}

class FacultyShimmer extends StatefulWidget {
  @override
  _FacultyShimmerState createState() => _FacultyShimmerState();
}

class _FacultyShimmerState extends State<FacultyShimmer> {
  @override
  Widget build(BuildContext context) {
    return Loader();
  }
}
