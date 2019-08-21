import 'package:flutter/material.dart';

import '../home_future_builder.dart';


class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Today's Classes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        ),
        Container(height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[TodayClassBuilder(),],
          ),
        ),
      ],
    );
  }
}