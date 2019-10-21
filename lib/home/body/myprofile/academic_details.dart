import 'package:flutter/material.dart';

class AcademicDetails extends StatelessWidget {
  final String enrollmentNumber;
  final String program;
  final String batch;
  final String semester;

  AcademicDetails(
      {Key key,
      @required this.enrollmentNumber,
      @required this.program,
      @required this.batch,
      @required this.semester})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Academic Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        AcademicDetail(
          icon: Icons.calendar_today,
          title: "Enrollment Number",
          subtitle: enrollmentNumber,
        ),
        AcademicDetail(
          icon: Icons.assignment,
          title: "Program",
          subtitle: program,
        ),
        AcademicDetail(
          icon: Icons.date_range,
          title: "Batch",
          subtitle: batch,
        ),
        AcademicDetail(
          icon: Icons.mail,
          title: "Semester",
          subtitle: "$semester",
        ),
      ],
    );
  }
}

class AcademicDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  AcademicDetail(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                icon,
                color: Color(0xff22419A).withOpacity(0.8),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200),
            ),
            title: Text(title),
            subtitle: Text(subtitle)),
        Divider(),

      ],
    );
  }
}
