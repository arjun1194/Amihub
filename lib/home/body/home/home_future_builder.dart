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
  Future todayClassFuture;
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
    todayClassFuture = amizoneRepository.fetchTodayClass();
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
            return isLight(context)
                ? HomeTodayClassShimmer(
                    colorTween: ColorTween(
                        begin: Color(0xffd6d6d6), end: Color(0xffe8e8e8)),
                  )
                : HomeTodayClassShimmer(
                    colorTween: ColorTween(
                        begin: Colors.grey, end: Colors.grey.shade700),
                  );
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
    int randomInt = Random().nextInt(lightColors.length);
    return Padding(
      padding: EdgeInsets.all(8),
      child: Material(
          shadowColor: isLight(context)
              ? lightColors.elementAt(randomInt)
              : Colors.grey.shade300,
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: isLight(context)
                        ? [
                            lightColors.elementAt(randomInt),
                            darkColors.elementAt(randomInt)
                          ]
                        : [Colors.blueGrey.shade900, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(13))),
            child: Stack(
              children: <Widget>[
                QuarterCircle(
                  circleAlignment: CircleAlignment.topRight,
                  color: Colors.white.withOpacity(0.1),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 15, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Error fetching Today's Class",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          child: TodayClassCard(
            todayClass.title,
            todayClass.facultyName.split(",")[0].split("[")[0],
            todayClass.color,
            todayClass.roomNo,
            todayClass.courseCode,
            start,
            end,
            isLight(context)
                ? lightColors[math.min(index, index % lightColors.length)]
                : Colors.blueGrey.shade900,
            isLight(context)
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
    int randomInt = Random().nextInt(lightColors.length);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        shadowColor: isLight(context)
            ? lightColors.elementAt(randomInt)
            : Colors.grey.shade300,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isLight(context)
                      ? [
                          lightColors.elementAt(randomInt),
                          darkColors.elementAt(randomInt)
                        ]
                      : [Colors.blueGrey.shade900, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
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
