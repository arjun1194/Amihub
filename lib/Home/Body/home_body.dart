import 'package:amihub/Components/donut_chart.dart';
import 'package:amihub/Components/horizontal_chart.dart';
import 'package:amihub/Home/Body/home/home_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .height;


    return ListView(scrollDirection: Axis.vertical, shrinkWrap: true,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text("Today's Classes",
            style: TextStyle(fontSize: 20),),
        ),
        Container(height: 0.35 * height,
          width: 0.95 * width,
          child: HomeTodayClassBuilder(),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text("Attendance Summary",
            style: TextStyle(fontSize: 20),),
        ),
        DonutChartFutureBuilder(),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text("Score Summary",
            style: TextStyle(fontSize: 20),),
        ),
        HorizontalChartBuilder(),
      ],
    );
  }
}