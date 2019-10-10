import 'dart:ui' as ui;

import 'package:amihub/Models/score.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalChartBuilder extends StatefulWidget {
  @override
  _HorizontalChartBuilderState createState() => _HorizontalChartBuilderState();
}

class _HorizontalChartBuilderState extends State<HorizontalChartBuilder> {
  @override
  Widget build(BuildContext context) {
    List<Score> score = [
      Score(semester: 1, cgpa: 6.23, sgpa: 6.23),
      Score(semester: 2, cgpa: 6.19, sgpa: 6.15),
      Score(semester: 3, cgpa: 5.89, sgpa: 5.3),
      Score(semester: 4, cgpa: 5.9, sgpa: 5.92),
      Score(semester: 5, cgpa: 6.17, sgpa: 7.21),
      Score(semester: 6, cgpa: 6.29, sgpa: 6.83),
    ];
    return HorizontalChart(score: score);
  }
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: AmizoneRepository().fetchCurrentScore(),
//      // a previously-obtained Future<String> or null
//      builder: (BuildContext context, AsyncSnapshot<List<Score>> snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.none:
//            return Text('');
//          case ConnectionState.active:
//          case ConnectionState.waiting:
//            return CircularProgressIndicator();
//          case ConnectionState.done:
//            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//            return HorizontalChartBuild(snapshot.data);
//        }
//        return Text(''); // unreachable
//      },
//    );
//  }

}

//class HorizontalChartShimmer extends StatelessWidget {
//  final List<Score> score = [Score(cgpa: 0, semester: 1, sgpa: 0)];
//
//  @override
//  Widget build(BuildContext context) {
//    var height = MediaQuery.of(context).size.height;
//    var width = MediaQuery.of(context).size.width;
//
//    var series = [
//      charts.Series<Score, String>(
//        id: 'cgpa',
//        domainFn: (Score score, _) => score.semester.toString(),
//        measureFn: (Score score, _) => score.cgpa,
//        data: score,
//      ),
//      charts.Series<Score, String>(
//        id: 'sgpa',
//        domainFn: (Score score, _) => score.semester.toString(),
//        measureFn: (Score score, _) => score.sgpa,
//        data: score,
//      ),
//    ];
//
//    return Padding(
//      padding: EdgeInsets.all(8),
//      child: Container(
//        height: 0.35 * height,
//        width: 0.95 * width,
//        decoration: BoxDecoration(
//            boxShadow: [
//              BoxShadow(
//                color: Colors.grey,
//                blurRadius: 6.0,
//                // has the effect of softening the shadow
//                spreadRadius: 1.0,
//                // has the effect of extending the shadow
//                offset: Offset(
//                  3.0, // horizontal, move right 10
//                  1.0, // vertical, move down 10
//                ),
//              )
//            ],
//            gradient: LinearGradient(
//                colors: [Colors.white, Colors.white],
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter),
//            borderRadius: BorderRadius.all(Radius.circular(10))),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Container(
//              height: 0.35 * height,
//              width: 0.6 * width,
//              child: HorizontalChart(
//                seriesList: series,
//                animate: true,
//              ),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

//     ""

class HorizontalChartBuild extends StatelessWidget {
  final List<Score> score;

  HorizontalChartBuild(this.score);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        shadowColor: ui.Color(0xffd6d6d6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 0.35 * height,
                  width: 0.9 * width,
                  margin: EdgeInsets.all(10),
                  child: HorizontalChart(score: score),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("CGPA"),
                    Text("SGPA")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class HorizontalChart extends StatelessWidget {
  final List<Score> score;
  List<Series<Score, int>> seriesList;

  HorizontalChart({Key key, @required this.score}) {
    this.seriesList = [
      Series<Score, int>(
        id: "cgpa",
        domainFn: (Score score, _) => score.semester,
        measureFn: (Score score, _) => score.cgpa,
        displayName: "CGPA",
        colorFn: (Score score, _) => Color.fromHex(code: "#6C63FF"),
        data: score,
      ),
      Series<Score, int>(
          id: "sgpa",
          domainFn: (Score score, _) => score.semester,
          measureFn: (Score score, _) => score.sgpa,
          colorFn: (Score score, _) => Color.fromHex(code: "#BAC8D5"),
          displayName: "SGPA",
          data: score)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        seriesList,
        primaryMeasureAxis: new NumericAxisSpec(
            tickProviderSpec: new StaticNumericTickProviderSpec(List.generate(
                10, (index) => TickSpec(index + 1, label: '${index + 1}'))),
            showAxisLine: true),
        domainAxis: NumericAxisSpec(
            tickProviderSpec: StaticNumericTickProviderSpec(List.generate(
                score.length,
                    (index) => TickSpec(index + 1, label: '${index + 1}')))),
        animate: true,
      ),
    );
  }
}
