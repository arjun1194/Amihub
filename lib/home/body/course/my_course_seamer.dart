import 'package:flutter/material.dart';

class MyCourseShimmer extends StatefulWidget {

  final ColorTween colorTween;


  MyCourseShimmer({this.colorTween});

  @override
  _MyCourseShimmerState createState() => _MyCourseShimmerState();
}

class _MyCourseShimmerState extends State<MyCourseShimmer>
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

    animation = widget.colorTween
        .animate(animationController)
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

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Container(
                    color: animation.value,
                    width: 0.5 * width,
                    height: 20,
                  ),
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
                onTap: () {},
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
