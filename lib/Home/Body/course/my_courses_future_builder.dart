import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_course_seamer.dart';

class MyCourseBuilder extends StatefulWidget {
  @override
  _MyCourseBuilderState createState() => _MyCourseBuilderState();
}

class _MyCourseBuilderState extends State<MyCourseBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
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
    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchMyCourses(semester),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:   return MyCourseSeamer();
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null)
              return Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("My Courses", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(32),
                              child: Icon(Icons.cloud_off, color: Colors.white,
                                size: 108,),
                              decoration: BoxDecoration(color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(999)),),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Could not fetch Courses',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18,),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Please Check Your internet and try again',),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            //TODO:get from backend that this semester doesn't have data yet
            if (snapshot.data == "blah")
              return Text("This Semester Data doesnt exist for you");


            //if data arrives
            return Padding(
              padding: const EdgeInsets.only(left: 4,right: 4,top: 8),
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Text("My Courses",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ), Padding(
                      padding: const EdgeInsets.only(left: 32,right: 32),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          Text("Semester",style: TextStyle(fontSize: 18),),
                          Padding(padding: const EdgeInsets.only(left: semesterPadding), child: DropdownButton<String>(value: dropdownValue, onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  semester =
                                      semesterList.indexOf(dropdownValue) + 1;
                                });
                              },
                              items: semesterList.map<DropdownMenuItem<String>>((String value) {return DropdownMenuItem<String>(value: value,child: Text(value),);}).toList(),
                            ),),
                        ],
                      ),
                    ),
                    Column(
                      children: List<Widget>.generate(snapshot.data.length,
                        (int index) {
                          var percentage = double.tryParse("${snapshot.data[index]['percentage']}").roundToDouble();
                          return Column(
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.only(left: 0, right: 8,),
                                title: Text(snapshot.data[index]['courseName']),
                                subtitle: Text(snapshot.data[index]['courseCode']),
                                leading: Container(color: (percentage < 75) ? Colors.red : (percentage >= 75 && percentage < 85) ? Colors.yellow : Colors.green, width: 8,),
                                trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${snapshot.data[index]['present']}/${snapshot.data[index]['total']} "),
                                    Text("(" + percentage.toString() + ")", style: TextStyle(color: Colors.black45))
                                  ],
                                ),
                                onTap: () {},
                              ),
                              (index != snapshot.data.length - 1) ? Divider() :
                              Padding(padding: EdgeInsets.all(16), child: Center(child: Text("Tap a Course for more details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)))),
                            ],
                          );
                        },
                      ),
                    ),
                  ]),
            );


          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }
}

