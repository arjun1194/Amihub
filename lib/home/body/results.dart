import 'dart:ui';

import 'package:amihub/components/animation_test.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/under_development.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeResults extends StatefulWidget {
  @override
  _HomeResultsState createState() => _HomeResultsState();
}

class _HomeResultsState extends State<HomeResults> {
  @override
  Widget build(BuildContext context) {
//    return ResultsBuilder();
    return ResultsBuilder();
  }
}

class ResultsBuilder extends StatefulWidget {
  @override
  _ResultsBuilderState createState() => _ResultsBuilderState();
}

class _ResultsBuilderState extends State<ResultsBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  int semester = 6;

  changeSemester(int sem) {
    setState(() {
      semester = sem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchResultsWithSemester(semester),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ResultsSeamer();
          case ConnectionState.done:
            if (snapshot.hasError) return ResultsError();
            if (snapshot.data.elementAt(0) == "No Class")
              return ResultNotFound();
            return Container(child: ResultBuild(
                snapshot: snapshot, onChange: changeSemester));
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(''); // unreachable
      },
    );
  }
}

class ResultBuild extends StatefulWidget {
  final AsyncSnapshot<List<dynamic>> snapshot;
  final Function(int) onChange;

  ResultBuild({Key key, this.snapshot, this.onChange}) : super(key: key);

  @override
  _ResultBuildState createState() => _ResultBuildState();
}

class _ResultBuildState extends State<ResultBuild>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    print(getCurrentSemScore());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PageHeader('Results'),
        Expanded(
          child: FutureBuilder(
            future: getCurrentSemScore(),
            builder: (context, AsyncSnapshot<Score> snapshot) {
              switch(snapshot.connectionState){

                case ConnectionState.none:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.done:
                  return (!snapshot.hasData || snapshot.data == null)
                      ? ResultNotFound()
                      : ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 15),
                    physics: BouncingScrollPhysics(),
                    children: resultCardList(snapshot.data),
                  );
              }
              return Text('end');
            },
          ),
        ),
      ],
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

  Future<Score> getCurrentSemScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    AmizoneRepository amizoneRepository = AmizoneRepository();
    var semester = sp.get('semester');
    Score score = await amizoneRepository.fetchCurrentScoreWithSemester(semester-1);
    //test to see if score prints correctly
    return score;
  }

  //Some util widgets
  List<Widget> resultCardList(Score score) {
    List<Widget> l = [];

    int n = widget.snapshot.data.length;
    l.add(Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 32, right: 32),
      child: card(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                //gaugeMeters row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    gaugeMeter(score.cgpa/10, "Cgpa"),
                    gaugeMeter(score.sgpa/10, "Sgpa"),
                  ],
                ),
//                summaryCardDetail("Rollno", "A2305216627"),
                summaryCardDetail("Semester", score.semester.toString()),
                summaryCardDetail("Courses", n.toString()),
              ],
            ),
          )),));
    for (int i = 0; i < n; i++) {
      Widget w = Padding(
        padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
        child: resultCard(
            widget.snapshot.data[i]['gradePoints'] / 10,
            widget.snapshot.data[i]['gradeObtained'].toString(),
            widget.snapshot.data[i]['courseTitle'],
            widget.snapshot.data[i]['courseCode'],
            widget.snapshot.data[i]['associatedCreditUnits'],
            widget.snapshot.data[i]['gradePoints'],
            widget.snapshot.data[i]['creditPoints']),
      );
      l.add(w);
    }
    return l;
  }


  Widget card({@required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 8,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 0.3,
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: child,
        ),
      ),
    );
  }

  Widget gaugeMeter(double cgpa, String text) {
    var p = math.pi;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: 2.4,
                child: Transform.rotate(
                  angle: -2 * p * (cgpa / 2),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(cgpaColor(
                          Colors.redAccent,
                          Colors.lightGreenAccent.shade400,
                          cgpa)
                          .value)),
                      value: cgpa,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${(cgpa * 10).toStringAsFixed(1)}",
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
    RandomColor _randomColor = RandomColor();
//    _randomColor.randomColor()
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget gradeIcon(double cgpa, String text) {
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
                        cgpa)
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
                        Colors.lightGreenAccent.shade400, cgpa),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget resultGridElement({@required IconData iconData,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.grey,
              ),
              Text(text)
            ],
          ),
        ],
      ),
    );
  }

  Widget resultCard(double cgpa,
      String text,
      String courseName,
      String courseCode,
      int associatedCreditUnits,
      int gradePoints,
      int creditPoints) {
    return card(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                gradeIcon(cgpa, text),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Wrap(children: <Widget>[
                          Text(
                            courseName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          )
                        ]),
                        Text(courseCode),
                      ],
                    ),
                  ),
                )
              ],
            ),
            GridView.count(
                primary: false,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
                padding: EdgeInsets.all(8),
                childAspectRatio: 2,
                shrinkWrap: true,
                children: <Widget>[
                  resultGridElement(
                      iconData: Icons.assignment,
                      text: "Subject Credits",
                      number: associatedCreditUnits.toString()),
                  resultGridElement(
                      iconData: Icons.assessment,
                      text: "Earned Points",
                      number: gradePoints.toString()),
                  resultGridElement(
                      iconData: Icons.assessment,
                      text: "Total Points",
                      number: creditPoints.toString()),
                  resultGridElement(
                      iconData: Icons.star,
                      text: "Subject Score",
                      number: "$creditPoints/${associatedCreditUnits * 10}"),
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

class ResultsSeamer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
