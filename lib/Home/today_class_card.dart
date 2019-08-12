import 'package:amihub/ViewModels/today_class_model.dart';
import 'package:flutter/material.dart';

class TodayClassCard extends StatelessWidget {
  TodayClass todayClass;
  Color color;

  TodayClassCard(this.todayClass,this.color);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8,bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(todayClass.courseCode,style: TextStyle(fontSize: 20,color: Colors.white),),
                  Text(todayClass.startTime,style: TextStyle(fontSize: 20,color: Colors.white),),

                ],),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(todayClass.courseTitle,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(todayClass.facultyName,style: TextStyle(fontSize: 20,color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(todayClass.roomNo,style: TextStyle(fontSize: 20,color: Colors.white),),
            ),

          ],),
        color:color,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
