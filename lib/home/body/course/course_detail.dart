import 'package:amihub/components/under_development.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  final Course course;

  const CoursePage({Key key, this.course}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
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
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: UnderDevelopment(),
    );
  }

}
