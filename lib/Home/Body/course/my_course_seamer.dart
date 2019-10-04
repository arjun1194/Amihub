import 'package:flutter/material.dart';

class MyCourseSeamer extends StatefulWidget {
  @override
  _MyCourseSeamerState createState() => _MyCourseSeamerState();
}

class _MyCourseSeamerState extends State<MyCourseSeamer>
    with SingleTickerProviderStateMixin {
  @override
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

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 8,
      itemBuilder: (context, int index) {
        if (index == 0)
          return Padding(
            padding: const EdgeInsets.only(top: 32, left: 32),
            child: Text(
              "My Courses",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
          );
        else
          return Column(
            children: <Widget>[
              ListTile(
                title: Container(
                  color: animation.value,
                  width: 0.5 * width,
                  height: 20,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0.6 * width, top: 8),
                  child: Container(color: animation.value, height: 10),
                ),
                contentPadding: EdgeInsets.only(left: 0),
                leading: Container(
                  decoration: BoxDecoration(
                    color: animation.value,
                  ),
                  width: 8,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text(" "), Text(" ")],
                ),
                onTap: () {},
              ),
              Divider(),
            ],
          );
      },
    );
  }
}
