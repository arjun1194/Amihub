import 'package:amihub/components/donut_chart.dart';
import 'package:amihub/components/horizontal_chart.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/home/body/home/home_future_builder.dart';
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
        PageHeader("Today's Class"),
        buildContainer(height, width, HomeTodayClassBuilder()),
        PageHeader("Attendance Summary"),
        // TODO : Change The Pie Chart
        buildContainer(height, width, DonutChartFutureBuilder()),
        PageHeader("Score Summary"),
        buildContainer(height, width, HorizontalChartBuilder()),
      ],
    );
  }

  Container buildContainer(double height, double width, Widget child) {
    return Container(height: 0.3 * height, width: 0.95 * width, child: child);
  }

}
