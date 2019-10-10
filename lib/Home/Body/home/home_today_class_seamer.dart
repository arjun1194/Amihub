import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTodayClassShimmer extends StatefulWidget {
  @override
  _HomeTodayClassShimmerState createState() => _HomeTodayClassShimmerState();
}

class _HomeTodayClassShimmerState extends State<HomeTodayClassShimmer>
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
      begin: const Color(0xffd6d6d6),
      end: const Color(0xffe8e8e8),
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
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Material(
          shadowColor: Colors.grey.shade200,
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white70, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.all(Radius.circular(13))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: getContainer(width * 0.7, 22),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.person_add_solid,
                        color: animation.value,
                        size: 28,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      getContainer(width * 0.4, 18)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        color: animation.value,
                        size: 28,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      getContainer(width * 0.3, 18)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_balance,
                            color: animation.value,
                            size: 28,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          getContainer(60, 18),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.21,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.description,
                            size: 28,
                            color: animation.value,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          getContainer(60, 18),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Container getContainer(double width, double height) {
    return Container(
      height: height,
      width: width,
      color: animation.value,
    );
  }
}
