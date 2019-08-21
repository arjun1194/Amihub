import 'package:flutter/material.dart';

class TodayClassSeamer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print("--------------------------->>" + height.toString());
    print("--------------------------->>" + width.toString());

    return Center(
        child: Stack(
      children: <Widget>[
        Container(
            height: 250,
            width: 0.9 * width,
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
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 300,
                                  height: 20,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Container(
                                      width: 120,
                                      height: 10,
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 10,
                            color: Colors.grey[400],
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ],
    ));
  }
}
