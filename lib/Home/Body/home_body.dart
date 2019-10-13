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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 15),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        buildPadding("Today's Class"),
        buildContainer(height, width, HomeTodayClassBuilder()),
        buildPadding("Attendance Summary"),
        // TODO : Change The Pie Chart
        buildContainer(height, width, DonutChartFutureBuilder()),
        buildPadding("Score Summary"),
        buildContainer(height, width, HorizontalChartBuilder()),
      ],
    );
  }

  Container buildContainer(double height, double width, Widget child) {
    return Container(height: 0.3 * height, width: 0.95 * width, child: child);
  }

  Padding buildPadding(String name) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 0),
      child: Text(
        name,
        style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
      ),
    );
  }
}
