import 'dart:convert';
import 'package:amihub/Components/hex_color.dart';
import 'package:amihub/Interceptors/amizone_http_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/ViewModels/today_class_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AmizoneRepository {


  Future<List<TodayClass>> fetchTodayClass() async {
    HttpWithInterceptor http = HttpWithInterceptor.build(
        interceptors: [AmizoneInterceptor("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJhdmlyaWFzIiwiY3NyZiI6IjI5ZmQ3ZmU3LWJiYjMtMTFlOS1iMWNmLTAzMjk4MGE2MjY5OSIsImlkIjo1NzIyMzgxLCJleHAiOjE1NzA2NjU2MDAsImlhdCI6MTU2NTQ3MTM3OCwianRpIjoiMjlmZDdmZTYtYmJiMy0xMWU5LWIxY2YtZTE5YjU1NTMzMWIyIn0.ONA7YKCmz2FvicauoSVtvs7Kd-PaaTPVimhHRV3vw6pm9wkZo8FaftgpqzhfffXd8Y56pVqt3bWM_sL7npebyg")]);

    var jsonData;
    List<TodayClass> todayClassList;
    try {
      var response = await http.get("$amihubUrl/todayClass?start=2019-08-06&end=2019-08-06");

      if (response.statusCode == 200) {
        if(response.body==""){

        }
         jsonData =  jsonDecode(response.body);
         int size = jsonData.length;
          todayClassList = List.generate(size, (int index){
            Color attendanceColor = HexColor(jsonData[index]['color']);
            String courseCode = jsonData[index]['courseCode'];
            String facultyName = jsonData[index]['facultyName'];
            String roomNo = jsonData[index]['roomNo'];
            String startTime = jsonData[index]['start'];
            String endTime = jsonData[index]['end'];
            String courseTitle = jsonData[index]['title'];
            return  TodayClass(attendanceColor,courseCode,courseTitle,facultyName,roomNo,startTime,endTime);
         });
      } else {
        throw Exception("Error while fetching. \n ${response.body}");
      }
    } catch (e) {
      print(e);
    }
    return todayClassList;
  }

}
