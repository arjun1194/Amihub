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
        interceptors: [AmizoneInterceptor()]);

    var jsonData;
    List<TodayClass> todayClassList;
    try {
      var response = await http.get("$amihubUrl/todayClass");

      if (response.statusCode == 200) {
        if(response.body==""){

        }
         jsonData =  jsonDecode(response.body);
         int size = jsonData.length;
          todayClassList = List.generate(size, (int index){
            Color attendanceColor = HexColor(jsonData[index]['color']);
            String courseCode = jsonData[index]['courseCode'];
            String facultyName = jsonData[index]['facultyName'].toString();
            var indexFacultySplit = facultyName.indexOf('[');
            facultyName = facultyName.substring(0,indexFacultySplit);
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
