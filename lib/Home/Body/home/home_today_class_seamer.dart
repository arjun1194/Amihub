import 'package:flutter/material.dart';

class HomeTodayClassSeamer extends StatefulWidget {
  @override
  _HomeTodayClassSeamerState createState() => _HomeTodayClassSeamerState();
}

class _HomeTodayClassSeamerState extends State<HomeTodayClassSeamer>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController animationController;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    animation = new ColorTween(
      begin: const Color(0xeadcdcdc),
      end: const Color(0xeaacacac),
    ).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 0.8 * width,
                  height: 20,
                  color: animation.value,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: 0.25 * width,
                    height: 10,
                    color: animation.value,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
