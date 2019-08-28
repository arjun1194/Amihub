import 'package:amihub/Home/my_courses_future_builder.dart';
import 'package:flutter/material.dart';


class HomeMyCourses extends StatefulWidget {
  @override
  _HomeMyCoursesState createState() => _HomeMyCoursesState();
}

class _HomeMyCoursesState extends State<HomeMyCourses> {

  String dropdownValue = 'One';
  static const semesterPadding = 8.0;

  //TODO:get this in metaData
  List<String> semesterList = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight'
  ];

  //TODO:get this in metaData
  int semester = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text("My Courses",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      ),
      Padding(
        padding: const EdgeInsets.only(right: semesterPadding),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Semester", style: TextStyle(fontSize: 18),),
            Padding(
              padding: const EdgeInsets.only(left: semesterPadding),
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    semester = semesterList.indexOf(dropdownValue) + 1;
                  });
                },
                items: semesterList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                    .toList(),
              ),
            ),
          ],
        ),
      ),

      Expanded(child: MyCourseBuilder(semester)),
    ],);
  }
}










