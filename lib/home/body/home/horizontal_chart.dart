import 'package:amihub/home/body/faculty/faculty_detail.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalChartBuilder extends StatefulWidget {
  final Function(Score) tapped;

  const HorizontalChartBuilder({Key key, this.tapped}) : super(key: key);
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
            return HorizontalChartBuild(snapshot.data,widget.tapped);
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
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              elevation: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                      color: blackOrWhite(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          side: BorderSide(
                            width: 0.3,
                            color: Colors.grey.shade400,
                          ))),
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
  final Function(Score) tapped;
  HorizontalChartBuild(this.score,this.tapped);

  @override
  Widget build(BuildContext context) {
    return score.length != 0
        ? Padding(
            padding: EdgeInsets.all(8),
            child: Material(
              color: Colors.transparent,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              elevation: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 3),
                  decoration: ShapeDecoration(
                      color: blackOrWhite(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          side: BorderSide(
                            width: 0.3,
                            color: Colors.grey.shade400,
                          ))),
                  child: HorizontalChart(score: score,tapped: tapped,),
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
  final Function(Score) tapped;

  HorizontalChart({Key key, @required this.score, this.tapped}) {
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
  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    Score score;

    if (selectedDatum.isNotEmpty) {
      score = selectedDatum.elementAt(0).datum as Score;
      widget.tapped(score);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: LineChart(
        widget.seriesList,
        defaultRenderer:
            LineRendererConfig(includeLine: true, includePoints: true),
        behaviors: [
          SeriesLegend(
            position: BehaviorPosition.inside,
            insideJustification: InsideJustification.topEnd,
          ),
        ],
        selectionModels: [
          SelectionModelConfig(
              type: SelectionModelType.info,
              changedListener: _onSelectionChanged)
        ],
        primaryMeasureAxis: new NumericAxisSpec(
            tickProviderSpec: new StaticNumericTickProviderSpec(List.generate(
                10,
                (index) => TickSpec(index + 1,
                    label: index % 2 != 0 ? '${index + 1}' : '',
                    style: TextStyleSpec(
                        color: isLight(context) ? Color.black : Color.white)))),
            showAxisLine: true),
        domainAxis: NumericAxisSpec(
            tickProviderSpec: StaticNumericTickProviderSpec(List.generate(
                widget.score.length,
                (index) => TickSpec(index + 1,
                    label: '${index + 1}',
                    style: TextStyleSpec(
                        color:
                            isLight(context) ? Color.black : Color.white))))),
        animate: true,
      ),
    );
  }
}
