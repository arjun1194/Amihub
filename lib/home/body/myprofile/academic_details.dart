import 'package:flutter/material.dart';

class AcademicDetails extends StatelessWidget {
  String enrollmentNumber;
  String program;
  String batch;
  String semester;

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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          subtitle: "$semester Semester",
        ),Divider(),
      ],
    );
  }
}

class AcademicDetail extends StatelessWidget {
  IconData icon;
  String title;
  String subtitle;

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
        Divider(),
        ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                icon,
                color: Color(0xff22419A),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Color(0xff0FCAED)),
            ),
            title: Text(title),
            subtitle: Text(subtitle)),

      ],
    );
  }
}

//Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Row(
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.all(8),
//            child: Icon(
//              icon,
//              color: Color(0xff22419A),
//            ),
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(999),
//                color: Color(0xff0FCAED)),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(left: 8.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Text(title,style: TextStyle(color: Color(0xff72777B))),
//                Text(
//                  subtitle,
//                  style: TextStyle(fontSize: 20,color: Colors.grey),
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    );
