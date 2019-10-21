import 'dart:ui' as ui;

import 'package:amihub/models/score.dart';
import 'package:amihub/repository/amizone_repository.dart';
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
    return FutureBuilder(
      future: AmizoneRepository().fetchCurrentScore(),
      builder: (BuildContext context, AsyncSnapshot<List<Score>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return HorizontalChartShimmer();
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return HorizontalChartBuild(snapshot.data);
        }
        return Text(''); // unreachable
      },
    );
  }
}

class HorizontalChartShimmer extends StatelessWidget {
  final List<Score> score = [Score(cgpa: 0, semester: 1, sgpa: 0)];

  @override
  Widget build(BuildContext context) {

    return score.length != 0
        ? Padding(
          padding: EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            shadowColor: ui.Color(0xffd6d6d6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)),
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: HorizontalChart(score: score),
              ),
            ),
          ),
        )
        : Container();
  }
}

class HorizontalChartBuild extends StatelessWidget {
  final List<Score> score;

  HorizontalChartBuild(this.score);

  @override
  Widget build(BuildContext context) {
    return score.length != 0
        ? Padding(
          padding: EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            shadowColor: ui.Color(0xffd6d6d6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)),
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: HorizontalChart(score: score),
              ),
            ),
          ),
        )
        : Container();
  }
}

// ignore: must_be_immutable
class HorizontalChart extends StatefulWidget {
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
  _HorizontalChartState createState() => _HorizontalChartState();
}

class _HorizontalChartState extends State<HorizontalChart> {
  String textSelected;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      widget.seriesList,
      defaultRenderer:
          LineRendererConfig(includeLine: true, includePoints: true),
      behaviors: [
        SeriesLegend(
          position: BehaviorPosition.inside,
          insideJustification: InsideJustification.topEnd,
        ),
      ],
      primaryMeasureAxis: new NumericAxisSpec(
          tickProviderSpec: new StaticNumericTickProviderSpec(List.generate(
              10, (index) => TickSpec(index + 1, label: '${index + 1}'))),
          showAxisLine: true),
      domainAxis: NumericAxisSpec(
          tickProviderSpec: StaticNumericTickProviderSpec(List.generate(
              widget.score.length,
              (index) => TickSpec(index + 1, label: '${index + 1}')))),
      animate: true,
    );
  }
}
