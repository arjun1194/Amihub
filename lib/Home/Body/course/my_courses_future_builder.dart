import 'package:amihub/Database/database_helper.dart';
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
  static const int currentSemester = 7;
  String dropdownValue = '';
  Future<dynamic> myFuture;
  static const semesterPadding = 10.0;
  List<String> semesterList;
  int semester;

  @override
  void initState() {
    super.initState();
    semester = currentSemester;
    semesterList = [
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight'
    ];
    dropdownValue = semesterList.elementAt(currentSemester - 1);
    myFuture = amizoneRepository.fetchMyCourses();
  }

  Future<void> onRefresh() async {
    //open to changes right now!
    await DatabaseHelper.db.deleteCourseWithSemester(semester);
    setState(() {});
  }

  Widget courseError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "My Courses",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
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
                    child: Icon(
                      Icons.cloud_off,
                      color: Colors.white,
                      size: 108,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Could not fetch Courses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please Check Your internet and try again',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget courseBuild(AsyncSnapshot<List<dynamic>> snapshot) {
    return Column(
      children: List<Widget>.generate(
        snapshot.data.length,
        (int index) {
          var percentage =
              double.tryParse("${snapshot.data[index]['percentage']}")
                  .roundToDouble();
          return Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 0,
                  right: 8,
                ),
                title: Text(
                  snapshot.data[index]['courseName'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(snapshot.data[index]['courseCode']),
                leading: Container(
                  color: (percentage < 75)
                      ? Colors.red
                      : (percentage >= 75 && percentage < 85)
                          ? Colors.yellow
                          : Colors.green,
                  width: 8,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "${snapshot.data[index]['present']}/${snapshot.data[index]['total']} "),
                    Text("(" + percentage.toString() + ")",
                        style: TextStyle(color: Colors.black45))
                  ],
                ),
                onTap: () {},
              ),
              Divider(),
              (index == snapshot.data.length - 1)
                  ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: Text("Tap a Course for more details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey))))
                  : Container()
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "My Courses",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Semester",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: semesterPadding),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        semester = semesterList.indexOf(dropdownValue) + 1;

                        myFuture = amizoneRepository
                            .fetchMyCoursesWithSemester(semester);
                      });
                    },
                    items: semesterList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          buildFutureBuilder(),
        ],
      ),
    );
  }

  FutureBuilder<List> buildFutureBuilder() {
    return FutureBuilder<List<dynamic>>(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return MyCourseShimmer();
          case ConnectionState.done:
            return (snapshot.hasError || snapshot.data == null)
                ? courseError()
                : courseBuild(snapshot);
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
