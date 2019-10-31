import 'dart:ui';

import 'package:amihub/components/animation_test.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/under_development.dart';
import 'package:amihub/models/result.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:math' as math;

import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeResults extends StatefulWidget {
  @override
  _HomeResultsState createState() => _HomeResultsState();
}

class _HomeResultsState extends State<HomeResults> {
  final AmizoneRepository amizoneRepository = AmizoneRepository();
  int semester;
  Score score;
  String dropdownValue = '';
  int userSemester;
  Future<List> resultFuture;
  bool isLoading = true;

  openSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return userSemester = sharedPreferences.getInt('semester');
  }

  Future<Score> getCurrentSemScore(int sem) async {
    return await amizoneRepository.fetchCurrentScoreWithSemester(sem);
  }

  @override
  void initState() {
    super.initState();
    openSharedPref().then((val) {
      setState(() {
        semester = val;
        dropdownValue = semesterList.elementAt(semester - 1);
        resultFuture = amizoneRepository.fetchResultsWithSemester(semester);
        isLoading = false;
      });
      return val;
    }).then((val) {
      getCurrentSemScore(val).then((sc) {
        score = sc;
      });
    });
  }

  changeSemester(int sem) async {
    score = await getCurrentSemScore(sem);
    setState(() {
      semester = sem;
      resultFuture = amizoneRepository.fetchResultsWithSemester(semester);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      child: semester == null || isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PageHeader('Results'),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Center(
                    child: Material(
                      shape: StadiumBorder(
                          side:
                              BorderSide(width: 1, color: Colors.grey.shade200)),
                      elevation: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        color: blackOrWhite(context),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: dropdownValue,
                          isExpanded: false,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              changeSemester(
                                  semesterList.indexOf(dropdownValue) + 1);
                            });
                          },
                          items:
                              semesterList.sublist(0, userSemester).map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: FutureBuilder<List<CourseResult>>(
                    future: resultFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CourseResult>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return ResultsShimmer();
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return ResultsError();
                          }
                          if (snapshot.data.length == 0) return ResultNotFound();
                          return Container(
                              child: ResultBuild(
                                  results: snapshot.data, score: score));
                        case ConnectionState.none:
                          break;
                        case ConnectionState.active:
                          break;
                      }
                      return Text(''); // unreachable
                    },
                  ),
                )
              ],
            ),
    );
  }
}

class ResultBuild extends StatefulWidget {
  final List<CourseResult> results;
  final Score score;

  const ResultBuild({Key key, this.results, this.score}) : super(key: key);

  @override
  _ResultBuildState createState() => _ResultBuildState();
}

class _ResultBuildState extends State<ResultBuild>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 15),
        physics: BouncingScrollPhysics(),
        children: resultCardList(),
      ),
    );
  }

  //Some utility functions
  Color cgpaColor(Color a, Color b, double cgpa) {
    //@params Color a: Lowest level to which color can fall
    //@params Color b: Highest level to which color can rise
    //@params double cgpa: a double number according to which color will change
    //@returns Color according to cgpa , a and b.
    assert(cgpa != null);
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    //setting  RGB linear interpolated values based on value of CGPA
    return Color.fromARGB(
      lerpDouble(a.alpha, b.alpha, cgpa).toInt().clamp(0, 255),
      lerpDouble(a.red, b.red, cgpa).toInt().clamp(0, 255),
      lerpDouble(a.green, b.green, cgpa).toInt().clamp(0, 255),
      lerpDouble(a.blue, b.blue, cgpa).toInt().clamp(0, 255),
    );
  }

  //Some util widgets
  List<Widget> resultCardList() {
    List<Widget> l = [];

    int n = widget.results.length;
    l.add(Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 12, right: 12),
      child: card(
          child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            //gaugeMeters row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                gaugeMeter(widget.score.cgpa / 10, "CGPA"),
                gaugeMeter(widget.score.sgpa / 10, "SGPA"),
              ],
            ),
            summaryCardDetail("Semester", widget.score.semester.toString()),
            summaryCardDetail("Courses", n.toString()),
          ],
        ),
      )),
    ));
    for (int i = 0; i < n; i++) {
      CourseResult courseResult = widget.results.elementAt(i);
      Widget w = Padding(
        padding: const EdgeInsets.only(left: 12, top: 10, right: 12),
        child: resultCard(courseResult),
      );
      l.add(w);
    }
    return l;
  }

  Widget card({@required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.3,
                color: Colors.grey.shade400,
              ),
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.light ? [
                  Color(0xffe6f8f9),Colors.white
                ]: [Color(0xff393e46),Color(0xff222831)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: child,
        ),
      ),
    );
  }

  Widget gaugeMeter(double gpa, String text) {
    var p = math.pi;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32,0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: 2.4,
                child: Transform.rotate(
                  angle: -2 * p * (gpa / 2),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(cgpaColor(
                              Colors.redAccent,
                              Colors.lightGreenAccent.shade400,
                              gpa)
                          .value)),
                      value: gpa,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${(gpa * 10).toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Text(text)
        ],
      ),
    );
  }

  Widget summaryCardDetail(String title, String body) {
    if (title == null) title = "";
    if (body == null) body = "";
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            body,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget gradeIcon(double gpa, String text) {
    var p = math.pi;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: 1.5,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(cgpaColor(
                            Colors.redAccent,
                            Colors.lightGreenAccent.shade400,
                            gpa)
                        .value)),
                    value: 1,
                  ),
                ),
              ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cgpaColor(Colors.redAccent,
                        Colors.lightGreenAccent.shade400, gpa),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget resultGridElement(
      {@required IconData iconData,
      @required String text,
      @required String number}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            number,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: Colors.grey,
                  size: 18,
                ),
                SizedBox(width: 4,),
                Text(text)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget resultCard(CourseResult courseResult) {
    return card(
        child: Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            gradeIcon(
                courseResult.gradePoints / 10, courseResult.gradeObtained),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Wrap(children: <Widget>[
                      Text(
                        courseResult.courseTitle,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      )
                    ]),
                    Text(courseResult.courseCode),
                  ],
                ),
              ),
            )
          ],
        ),
        GridView.count(
            primary: false,
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            shrinkWrap: true,
            children: <Widget>[
              resultGridElement(
                  iconData: Icons.assignment,
                  text: "Subject Credits",
                  number: courseResult.associatedCreditUnits.toString()),
              resultGridElement(
                  iconData: Icons.assessment,
                  text: "Earned Points",
                  number: courseResult.gradePoints.toString()),
              resultGridElement(
                  iconData: Icons.assessment,
                  text: "Total Points",
                  number: courseResult.creditPoints.toString()),
              resultGridElement(
                  iconData: Icons.star,
                  text: "Subject Score",
                  number:
                      "${courseResult.creditPoints}/${courseResult.associatedCreditUnits * 10}"),
            ]),
      ],
    ));
  }
}

//returns a guageMeter

//Container(height: 100,width: 100,color: Colors.red,)

class ResultNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Result hasnt been uploaded yet"));
  }
}

class ResultsError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error Occured'),
    );
  }
}

class ResultsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
