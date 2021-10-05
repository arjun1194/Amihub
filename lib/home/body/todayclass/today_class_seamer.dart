import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TodayClassShimmer extends StatefulWidget {
  
  final ColorTween colorTween;

  TodayClassShimmer({this.colorTween});

  @override
  _TodayClassShimmerState createState() => _TodayClassShimmerState();
}

class _TodayClassShimmerState extends State<TodayClassShimmer>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    animation = widget.colorTween.animate(animationController)
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
    var width = MediaQuery.of(context).size.width;

    return AnimationLimiter(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 6,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Container(
                          color: animation.value,
                          width: width * 0.5,
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
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
