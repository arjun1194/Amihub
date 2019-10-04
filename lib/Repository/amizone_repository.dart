import 'dart:convert' as convert;

import 'package:amihub/Database/database_helper.dart';
import 'package:amihub/Interceptors/amizone_http_interceptor.dart';
import 'package:amihub/Models/course.dart';
import 'package:amihub/Models/today_class.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AmizoneRepository {


  DatabaseHelper dbHelper = DatabaseHelper.db;


  Future<List<dynamic>> fetchResultsWithSemester(int semester) async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/result?semester=$semester');
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }


  Future<List<dynamic>> fetchTodayClass() async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/todayClass');
    return await convert.jsonDecode(response.body);
  }

//  Future<List<dynamic>> fetchTodayClassWithDate(
//      String start, String end) async {
//    HttpWithInterceptor http =
//    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
//    var response =
//    await http.get('$amihubUrl/todayClass?start=$start&end=$end');
//    return await convert.jsonDecode(response.body);
//  }


  Future<List<dynamic>> fetchTodayClassWithDate(String start,
      String end) async {
    var dbResponse = await dbHelper.getTodayClassesWithDate(start);
    List<dynamic> todayClass = [];
    List<dynamic> noclass = ['No Class'];
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http = HttpWithInterceptor.build(
          interceptors: [AmizoneInterceptor()]);
      var response = await http.get(
          'http://api.avirias.me:8080/todayClass?start=$start&end=$end');
      if (response.body.toString() == '["No Class"]') return noclass;
      var jsonResponse = convert.jsonDecode(response.body);
      for (var item in jsonResponse) {
        todayClass.add(item);
        dbHelper.addTodayClass(TodayClass.fromJson(item));
      }
      return todayClass;
    }
    for (var item in dbResponse) {
      todayClass.add(item.toJson());
    }
    return todayClass;
  }

//  Future<List<dynamic>> fetchMyCoursesWithSemester(int semester) async {
//    HttpWithInterceptor http =
//        HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
//    var response = await http.get('$amihubUrl/myCourses?semester=$semester');
//    var jsonResponse = convert.jsonDecode(response.body);
//    return jsonResponse;
//  }


  Future<List<dynamic>> fetchMyCoursesWithSemester(int semester) async {
    print("hihihihh");
    var dbResponse = await dbHelper.getCourseWithSemester(semester);
    print(dbResponse.toString());
    List<dynamic> courses = [];
    if (dbResponse.isEmpty) {
      print("im in");
      HttpWithInterceptor http = HttpWithInterceptor.build(
          interceptors: [AmizoneInterceptor()]);
      var response = await http.get(
          'http://api.avirias.me:8080/myCourses?semester=$semester');
      var jsonResponse = convert.jsonDecode(response.body);

      for (var item in jsonResponse) {
        item.putIfAbsent('semester', () => semester);
        courses.add(item);
        dbHelper.addCourse(Course.fromJson(item));
      }
      print("im outside if now \n\n");
      courses.forEach((course) {
        print(course.toString());
      });
      List<Course> test = await dbHelper.getCourseWithSemester(semester);
      test.forEach((course) {
        print("course from databse--->" + course.toJson().toString());
      });
      return courses;
    }
    for (var item in dbResponse) {
      print(item.toJson());
      courses.add(item.toJson());
    }
    return courses;
  }


  Future<List<dynamic>> fetchMyCourses() async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/myCourses?semester');
    //print(jsonDecode(response.body));
    return await convert.jsonDecode(response.body);
  }


  Future<dynamic> fetchMyProfile() async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/myProfile');
    //print(jsonDecode(response.body));
    return await convert.jsonDecode(response.body);
  }

  Future<Response> loginWithCaptcha(String username, String password,
      String gcaptcha) async {
    Client client = Client();
    String url = amihubUrl +
        "/login?username=$username&password=$password&captchaResponse=$gcaptcha";
    Response resp = await client.get(url);
    return resp;
  }

  Future<Response> login(String username, String password) async {
    Client client = Client();
    String url = amihubUrl + "/login";
    print("--->$username" + "---->$password");
    String requestBody = '{"username":$username, "password":"$password"}';
    var headers = {"content-type": "application/json"};
    Response resp = await client.post(url, headers: headers, body: requestBody);

    return resp;
  }
}
