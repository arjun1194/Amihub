import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class TestAnimation extends StatefulWidget {
  @override
  _TestAnimationState createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;


  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this,);
    animation = Tween<double>(begin: 0, end: 255).animate(controller)
      ..addListener(() {
        setState(() {
          print(animation.value);
        });
      });
    if (controller.value == 255)
      controller.reverse();
    else if (controller.value == 0) controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(
      padding: EdgeInsets.all(animation.value),
      child: Container(width: 300, height: 300, child: FlutterLogo()),
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}
