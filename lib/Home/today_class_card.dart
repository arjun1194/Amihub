import 'package:amihub/ViewModels/today_class_model.dart';
import 'package:flutter/material.dart';

class TodayClassCard extends StatelessWidget {
  TodayClass todayClass;
  Color color;

  TodayClassCard(this.todayClass,this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(todayClass.courseCode,style: TextStyle(fontSize: 20,fontFamily: "Raleway",color: Colors.white),),
                    Text(todayClass.startTime,style: TextStyle(fontSize: 20,fontFamily: "Raleway",color: Colors.white),),

                  ],),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(todayClass.courseTitle,style: TextStyle(fontSize: 20,fontFamily: "Raleway",color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(todayClass.facultyName,style: TextStyle(fontSize: 20,fontFamily: "Raleway",color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(todayClass.roomNo,style: TextStyle(fontSize: 20,fontFamily: "Raleway",color: Colors.white),),
              ),

            ],),
        ),
      ),
      color:color,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
    );
  }
}
