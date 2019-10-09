import 'package:amihub/Models/score.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalChartBuilder extends StatefulWidget {
  @override
  _HorizontalChartBuilderState createState() => _HorizontalChartBuilderState();
}

class _HorizontalChartBuilderState extends State<HorizontalChartBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AmizoneRepository().fetchcurrentScore(),
      // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<Score>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return HorizontalChartSeamer();
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return HorizontalChartBuild(snapshot.data);
        }
        return Text(''); // unreachable
      },
    );
  }
}

class HorizontalChartSeamer extends StatelessWidget {
  final List<Score> score = [Score(cgpa: 0, semester: 1, sgpa: 0)];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var series = [
      charts.Series<Score, String>(
        id: 'cgpa',
        domainFn: (Score score, _) => score.semester.toString(),
        measureFn: (Score score, _) => score.cgpa,
        data: score,
      ),
      charts.Series<Score, String>(
        id: 'sgpa',
        domainFn: (Score score, _) => score.semester.toString(),
        measureFn: (Score score, _) => score.sgpa,
        data: score,
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 0.35 * height,
        width: 0.95 * width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6.0,
                // has the effect of softening the shadow
                spreadRadius: 1.0,
                // has the effect of extending the shadow
                offset: Offset(
                  3.0, // horizontal, move right 10
                  1.0, // vertical, move down 10
                ),
              )
            ],
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
              width: 0.6 * width,
              child: HorizontalChart(
                seriesList: series,
                animate: true,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }
}

//     ""

class HorizontalChartBuild extends StatelessWidget {
  final List<Score> score;

  HorizontalChartBuild(this.score);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var series = [
      charts.Series<Score, String>(
        id: 'cgpa',
        domainFn: (Score score, _) => score.semester.toString(),
        measureFn: (Score score, _) => score.cgpa,
        data: score,
      ),
      charts.Series<Score, String>(
        id: 'sgpa',
        domainFn: (Score score, _) => score.semester.toString(),
        measureFn: (Score score, _) => score.sgpa,
        data: score,
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 0.35 * height,
        width: 0.95 * width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6.0,
                // has the effect of softening the shadow
                spreadRadius: 1.0,
                // has the effect of extending the shadow
                offset: Offset(
                  3.0, // horizontal, move right 10
                  1.0, // vertical, move down 10
                ),
              )
            ],
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
              child: HorizontalChart(seriesList: series, animate: true),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalChart({Key key, @required this.seriesList, @required this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      vertical: false,
    ));
  }
}
