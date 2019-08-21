import 'package:amihub/Components/today_class_card.dart';
import 'package:amihub/ViewModels/today_class_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayClassCard extends StatelessWidget {
  TodayClass todayClass;
  List<Color> colorList;

  TodayClassCard(this.todayClass, this.colorList);

  @override
  Widget build(BuildContext context) {
    int attendanceState = -1;
    print('"- - - - - >>>' + todayClass.attendanceColor.toString());
    todayClass.attendanceColor == "#4FCC4F"
        ? attendanceState = 1
        : todayClass.attendanceColor == "#f00"
            ? attendanceState = 2
            : attendanceState = 0;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: (todayClass.courseCode == "No Classes Today")
          ? Text("No classes today")
          : TestWidget(
              todayClass.courseTitle,
              todayClass.facultyName,
              attendanceState,
              todayClass.roomNo,
              todayClass.courseCode,
              todayClass.startTime,
              todayClass.endTime,
              colorList[0],
              colorList[1]),
    );
  }
}
