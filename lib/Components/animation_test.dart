import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestAnimation extends StatefulWidget {
  @override
  _TestAnimationState createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation> {
  Animation<double> animation;
  AnimationController controller;

  PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: PageView(
        onPageChanged: (int val) {
          pageController.animateToPage(val,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        },
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(width: 300, height: 300, color: Colors.red,),
          Container(width: 300, height: 300, color: Colors.green,),
          Container(width: 300, height: 300, color: Colors.yellow,),
          Container(width: 300, height: 300, color: Colors.blue,),
        ],
        pageSnapping: true,
        controller: pageController,
      ),
    ),);
  }
}
