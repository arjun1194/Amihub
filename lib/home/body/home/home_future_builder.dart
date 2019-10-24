import 'dart:math' as math;
import 'dart:math';

import 'package:amihub/home/body/home/home_today_class_card.dart';
import 'package:amihub/home/body/home/home_today_class_seamer.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTodayClassBuilder extends StatefulWidget {
  @override
  _HomeTodayClassBuilderState createState() => _HomeTodayClassBuilderState();
}

class _HomeTodayClassBuilderState extends State<HomeTodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  int currentPage;
  PageController pageController;

  changePage(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<List<TodayClass>>(
      future: amizoneRepository.fetchTodayClass(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TodayClass>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return HomeTodayClassShimmer();
          case ConnectionState.done:
            return (snapshot.hasError || snapshot.data == null)
                ? errorClassBuilder()
                : (snapshot.data.elementAt(0).title == "")
                    ? noClassBuilder(height, width)
                    : todayClassBuilder(snapshot);

          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // Unreachable
      },
    );
  }

  Padding errorClassBuilder() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
          child: Icon(
        Icons.cloud_off,
        size: 32,
        color: Colors.grey,
      )),
    );
  }

  PageView todayClassBuilder(AsyncSnapshot<List<TodayClass>> snapshot) {
    return PageView(
      onPageChanged: (int val) {
        currentPage = val;
        pageController.animateToPage(val,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      },
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      children: List.generate(snapshot.data.length, (index) {
        TodayClass todayClass = snapshot.data.elementAt(index);
        DateTime end =
            DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.end);
        DateTime start =
            DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(todayClass.start);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TestWidget(
            todayClass.title,
            todayClass.facultyName.split(",")[0].split("[")[0],
            todayClass.color,
            todayClass.roomNo,
            todayClass.courseCode,
            start,
            end,
            Theme.of(context).brightness == Brightness.light
                ? lightColors[math.min(index, index % lightColors.length)]
                : Colors.blueGrey.shade900,
            Theme.of(context).brightness == Brightness.light
                ? darkColors[math.min(index, index % lightColors.length)]
                : Colors.black,
          ),
        );
      }),
      pageSnapping: true,
      controller: pageController,
    );
  }

  Padding noClassBuilder(double height, double width) {
    int randomColor = Random().nextInt(lightColors.length);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 23),
      child: Material(
        shadowColor: Colors.grey.shade300,
        elevation: 10,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                lightColors.elementAt(randomColor),
                darkColors.elementAt(randomColor)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: Stack(
            children: <Widget>[
              QuarterCircle(
                circleAlignment: CircleAlignment.topRight,
                color: Colors.white.withOpacity(0.1),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 15, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "No Class Today",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Sit back and relax !",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.95)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
