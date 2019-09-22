import 'dart:convert';

import 'package:amihub/Interceptors/amizone_http_interceptor.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AmizoneRepository {


  Future<List<dynamic>> fetchTodayClass() async {
    HttpWithInterceptor http = HttpWithInterceptor.build(
        interceptors: [AmizoneInterceptor()]);
    var response = await http.get(
        '$amihubUrl/todayClass');
//    print(jsonDecode("*******************"+response.body.toString()));
    return await jsonDecode(response.body);
  }

  Future<List<dynamic>> fetchMyCourses(int semester) async {
    HttpWithInterceptor http = HttpWithInterceptor.build(
        interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/myCourses?semester=$semester');
    //print(jsonDecode(response.body));
    return await jsonDecode(response.body);
  }

  Future<List<dynamic>> fetchTodayClassWithDate(String start,
      String end) async {
    HttpWithInterceptor http = HttpWithInterceptor.build(
        interceptors: [AmizoneInterceptor()]);
    var response = await http.get(
        '$amihubUrl/todayClass?start=$start&end=$end');
    //print(jsonDecode(response.body));
    return await jsonDecode(response.body);
  }

  Future<dynamic> fetchMyProfile() async {
    HttpWithInterceptor http = HttpWithInterceptor.build(
        interceptors: [AmizoneInterceptor()]);
    var response = await http.get(
        '$amihubUrl/myProfile' );
    //print(jsonDecode(response.body));
    return await jsonDecode(response.body);
  }

}
