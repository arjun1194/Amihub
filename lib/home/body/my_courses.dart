import 'package:amihub/home/body/course/my_courses_future_builder.dart';
import 'package:flutter/material.dart';

class HomeMyCourses extends StatefulWidget {
  final bool isHeader;

  const HomeMyCourses({Key key, this.isHeader}) : super(key: key);
  @override
  _HomeMyCoursesState createState() => _HomeMyCoursesState();
}

class _HomeMyCoursesState extends State<HomeMyCourses> {



  @override
  Widget build(BuildContext context) {
    return MyCourseBuilder(isHeader: widget.isHeader,);
  }
}










