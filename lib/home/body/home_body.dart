import 'package:amihub/components/donut_chart.dart';
import 'package:amihub/components/horizontal_chart.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/home/body/home/home_future_builder.dart';
import 'package:amihub/repository/refresh_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  RefreshRepository refreshRepository = RefreshRepository();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeader("Today's Class"),
          SizedBox(height: 5,),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 15),
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                buildContainer(height, width, HomeTodayClassBuilder()),
                PageHeader("Attendance Summary"),
                // TODO : Change The Pie Chart
                buildContainer(height, width, DonutChartFutureBuilder()),
                // TODO : Remove this for 1st semester
                PageHeader("Score Summary"),
                buildContainer(height, width, HorizontalChartBuilder()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: RefreshButton(onPressed: onRefresh,),
    );
  }

  onRefresh(){
    refreshRepository.refreshTodayClass(DateFormat("MM/dd/yyyy").format(DateTime.now()));
    setState(() {});
  }

  Container buildContainer(double height, double width, Widget child) {
    return Container(height: 0.3 * height, width: 0.95 * width, child: child);
  }

}

