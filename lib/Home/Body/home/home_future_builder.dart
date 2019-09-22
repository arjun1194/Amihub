import 'dart:math' as math;

import 'package:amihub/Repository/amizone_repository.dart';
import 'package:amihub/Theme/theme.dart';
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
    currentPage = 0;
    pageController = PageController(initialPage: currentPage);
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;

    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchTodayClass(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return HomeTodayClassSeamer();

          case ConnectionState.done:
            return
              (snapshot.hasError || snapshot.data == null) ? Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  height: 0.3 * height,
                  width: 0.95 * width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6.0,
                          // has the effect of softening the shadow
                          spreadRadius: 1.0,
                          // has the effect of extending the shadow
                          offset: Offset(
                            3.0, // horizontal, move right 10
                            1.0, // vertical, move down 10
                          ),
                        )
                      ],
                      gradient: LinearGradient(
                          colors: [Colors.white70, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(child: Icon(
                    Icons.cloud_off, size: 32, color: Colors.grey,)),
                ),
              ) :
              (snapshot.data.elementAt(0) == "No Class") ? Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 0.3 * height,
                width: 0.95 * width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 6.0,
                        // has the effect of softening the shadow
                        spreadRadius: 1.0,
                        // has the effect of extending the shadow
                        offset: Offset(
                          3.0, // horizontal, move right 10
                          1.0, // vertical, move down 10
                        ),
                      )
                    ],
                    gradient: LinearGradient(
                        colors: [Colors.white70, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(child: Icon(
                  Icons.cloud_off, size: 32, color: Colors.grey,)),
              ),
              ) :
              PageView(
              onPageChanged: (int val) {
                currentPage = val;
                pageController.animateToPage(val,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              },
              scrollDirection: Axis.horizontal,
              children: List.generate(snapshot.data.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TestWidget(
                      snapshot.data[index]['title'],
                      snapshot.data[index]['facultyName']
                          .toString()
                          .substring(
                          0,
                          snapshot.data[index]['facultyName']
                              .toString()
                              .indexOf('[')),
                      snapshot.data[index]['color'],
                      snapshot.data[index]['roomNo'],
                      snapshot.data[index]['courseCode'],
                      snapshot.data[index]['start'],
                      snapshot.data[index]['end'],
                      lightColors[
                      math.max(index, index % lightColors.length)],
                      darkColors[
                      math.max(index, index % lightColors.length)]),
                );
              }),
              pageSnapping: true,
              controller: pageController,
            );



          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }
}
