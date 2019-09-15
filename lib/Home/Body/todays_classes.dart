import 'package:amihub/Home/Body/todayclass/today_class_builder.dart';
import 'package:flutter/material.dart';


class HomeTodayClass extends StatefulWidget {
  @override
  _HomeTodayClassState createState() => _HomeTodayClassState();
}

class _HomeTodayClassState extends State<HomeTodayClass> {


  @override
  Widget build(BuildContext context) {
    return TodayClassBuilder();
  }
}
