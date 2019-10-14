import 'dart:math' as math;

import 'package:amihub/models/today_class.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_today_class_card.dart';
import 'home_today_class_seamer.dart';

class HomeTodayClassBuilder extends StatefulWidget {
  @override
  _HomeTodayClassBuilderState createState() => _HomeTodayClassBuilderState();
}

class _HomeTodayClassBuilderState extends State<HomeTodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  int currentPage;
  PageController pageController;

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
      builder: (BuildContext context, AsyncSnapshot<List<TodayClass>> snapshot) {
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
      children: List.generate(snapshot.data.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TestWidget(
              snapshot.data[index].title,
              snapshot.data[index].facultyName.toString().substring(0,
                  snapshot.data[index].facultyName.toString().indexOf('[')),
              snapshot.data[index].color,
              snapshot.data[index].roomNo,
              snapshot.data[index].courseCode,
              snapshot.data[index].start,
              snapshot.data[index].end,
              lightColors[math.min(index, index % lightColors.length)],
              darkColors[math.min(index, index % lightColors.length)]),
        );
      }),
      pageSnapping: true,
      controller: pageController,
    );
  }

  Padding noClassBuilder(double height, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 23),
      child: Material(
        shadowColor: Colors.grey.shade300,
        elevation: 10,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.hotel,
                size: 30,
              ),
              Text(
                "No Class Today",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
