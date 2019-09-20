import 'package:amihub/Home/Body/home/home_future_builder.dart';
import 'package:flutter/material.dart';


class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .height;


    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text("Today's Classes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        ),
        Container(height: 0.3 * height,
          width: 0.95 * width,
          child: HomeTodayClassBuilder(),
        ),
      ],
    );
  }
}