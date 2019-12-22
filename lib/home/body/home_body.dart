import 'package:amihub/components/donut_chart.dart';
import 'package:amihub/components/horizontal_chart.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/components/refresh_button.dart';
import 'package:amihub/components/utilities.dart';
import 'package:amihub/home/body/home/home_future_builder.dart';
import 'package:amihub/repository/refresh_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  RefreshRepository refreshRepository = RefreshRepository();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: isLight(context) ? Colors.white : Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeader("Today's Class"),
          SizedBox(height: 4,),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 15),
              children: <Widget>[
                buildContainer(
                    height, width, scaleFactor, HomeTodayClassBuilder()),
                PageHeader("Attendance Summary"),
                // TODO : Change The Pie Chart
                buildContainer(
                    height, width, scaleFactor, DonutChartFutureBuilder()),
                // TODO : Remove this for 1st semester
                PageHeader("Score Summary"),
                Container(
                    height: height / width < 2.0 ? height * 0.31 * scaleFactor : height * 0.31 * scaleFactor,
                    width: width * 0.95,
                    child: HorizontalChartBuilder()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: RefreshButton(onPressed: () {
        scaffoldKey.currentState.showSnackBar(platformSnackBar(
          content: Text('Refreshing'),
          elevation: 8,
          duration: Duration(milliseconds: 500),
        ));
        refresh();
      }),
    );
  }

  Future<Null> refresh() async {
    await Utility.checkInternet().then((onValue) async {
      await refreshRepository
          .refreshTodayClass(DateFormat("MM/dd/yyyy").format(DateTime.now()))
          .then((val) async {
        await refreshRepository.refreshMetadata().then((val) {
          setState(() {});
          scaffoldKey.currentState.showSnackBar(platformSnackBar(
            content: Text('Updated...'),
            duration: Duration(milliseconds: 500),
          ));
        });
      });
    }).catchError((onError) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String time = sharedPreferences.getString("lastTimeTCUpdated");
      DateTime lastTime = DateTime.parse(time);
      scaffoldKey.currentState.showSnackBar(platformSnackBar(
        content: Text(
          "Can't connect to our server.\nlast updated ${Utility.lastTimeUpdated(lastTime)} ago",
        ),
        duration: Duration(milliseconds: 1200),
      ));
    });
  }

  Container buildContainer(
      double height, double width, double scaleFactor, Widget child) {
    if (height / width < 2)
      return Container(
          height: 0.3 * height * scaleFactor,
          width: 0.95 * width,
          child: child);
    return Container(
      height: 0.26 * height * scaleFactor,
      width: 0.95 * width,
      child: child,
    );
  }
}
