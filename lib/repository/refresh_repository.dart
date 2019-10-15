import 'dart:convert' as convert;
import 'package:amihub/database/database_helper.dart';
import 'package:amihub/interceptors/amizone_http_interceptor.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_with_interceptor.dart';

class RefreshRepository {
  DatabaseHelper dbHelper = DatabaseHelper.db;

  refreshTodayClass(String date) async {
    List<TodayClass> todayClass = [];
    HttpWithInterceptor http =
        HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response =
        await http.get('$amihubUrl/todayClass?start=$date&end=$date');
    if (response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body);
      for (var item in jsonResponse) {
        TodayClass td = TodayClass.fromJson(item);
        todayClass.add(td);
        dbHelper.addTodayClass(td);
      }
    }
  }
}
