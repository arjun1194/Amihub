import 'package:flutter/material.dart';


class HomeMyCourses extends StatefulWidget {
  @override
  _HomeMyCoursesState createState() => _HomeMyCoursesState();
}

class _HomeMyCoursesState extends State<HomeMyCourses> {

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Text("My Courses",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text("Semester",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
                .toList(),
          ),
        ],
      ),
      ListView.builder(scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, item) {
            return Column(children: <Widget>[
              ListTile(leading: Icon(Icons.account_circle, size: 64,),
                title: Text("Object Oriented System Design"),
                subtitle: Text("Dr. Geetika"),),
              Divider(),
            ],);
          })
    ],);
  }
}
