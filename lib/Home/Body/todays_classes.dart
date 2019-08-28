import 'package:amihub/Home/Body/today_class_builder.dart';
import 'package:flutter/material.dart';

class HomeTodayClass extends StatefulWidget {
  @override
  _HomeTodayClassState createState() => _HomeTodayClassState();
}

class _HomeTodayClassState extends State<HomeTodayClass> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text("Today's Classes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Date", style: TextStyle(fontSize: 18),),
          //add date picker here
        ],
      ),

      Expanded(child: Container(child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: TodayClassBuilder("8/28/2019", "8/28/2019"),
      ),)),
    ],);
  }
}
