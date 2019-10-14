import 'dart:convert' as convert;

import 'package:amihub/database/database_helper.dart';
import 'package:amihub/interceptors/amizone_http_interceptor.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/models/course_attendance.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmizoneRepository {
  DatabaseHelper dbHelper = DatabaseHelper.db;

  Future<List<CourseAttendance>> fetchCurrentAttendance() async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/metadata');
    var jsonResponse = convert.jsonDecode(response.body);
    List<CourseAttendance> courseAttendance = [];
    for (var elements in jsonResponse['attendance']) {
      String perc = elements['percentage'].toString();
      courseAttendance.add(CourseAttendance(elements['courseName'],
          double.tryParse(perc.substring(0, perc.indexOf("%")))));
    }

    List<CourseAttendance> courseAttend = List.generate(3, (int index) {
      return CourseAttendance("$index", 0.0);
    });

    List<double> justList = List.generate(3, (index) => 0.0);

    courseAttendance.forEach((course) {
      if (course.attendance < 75) {
        courseAttend
            .elementAt(0)
            .attendance += course.attendance;
        justList[0] += 1;
      }
      else if (course.attendance >= 75 && course.attendance < 85) {
        courseAttend
            .elementAt(1)
            .attendance += course.attendance;
        justList[1] += 1;
      }
      else {
        courseAttend
            .elementAt(2)
            .attendance += course.attendance;
        justList[2] += 1;
      }
    });


    for (int i = 0; i < courseAttend.length; i++) {
      courseAttend[i].attendance = justList[i];
    }
    return courseAttend;
  }

  Future<List<Score>> fetchCurrentScore() async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/metadata');
    var jsonResponse = convert.jsonDecode(response.body);
    List<Score> courseAttendance = [];
    for (var elements in jsonResponse['results']) {
      courseAttendance.add(Score(
        semester: int.tryParse(elements['semester'].toString()),
        cgpa: double.tryParse(elements['cgpa'].toString()),
        sgpa: double.tryParse(elements['sgpa'].toString()),
      ));
    }
    return courseAttendance;
  }

  Future<List<dynamic>> fetchResultsWithSemester(int semester) async {
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/result?semester=$semester');
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  Future<List<TodayClass>> fetchTodayClass() async {
    List<TodayClass> todayClass = [];
    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/todayClass');
    var jsonResponse = convert.jsonDecode(response.body);
    for (var element in jsonResponse) {
      todayClass.add(TodayClass.fromJson(element));
    }
    return todayClass;
  }

//  Future<List<dynamic>> fetchTodayClassWithDate(
//      String start, String end) async {
//    HttpWithInterceptor http =
//    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
//    var response =
//    await http.get('$amihubUrl/todayClass?start=$start&end=$end');
//    return await convert.jsonDecode(response.body);
//  }

  Future<List<TodayClass>> fetchTodayClassWithDate(String start,
      String end) async {
    List<TodayClass> dbResponse = await dbHelper.getTodayClassesWithDate(start);
    List<TodayClass> todayClass = [];
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http =
      HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response = await http
          .get('$amihubUrl/todayClass?start=$start&end=$end');
      var jsonResponse = convert.jsonDecode(response.body);
      for (var item in jsonResponse) {
        todayClass.add(item);
        dbHelper.addTodayClass(TodayClass.fromJson(item));
      }
      return todayClass;
    }
    for (var item in dbResponse) {
      todayClass.add((item));
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

  Future<List<Course>> fetchMyCoursesWithSemester(int semester) async {
    print("Network");
    List<Course> dbResponse = await dbHelper.getCourseWithSemester(semester);
    List<Course> courses = [];
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http =
      HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response = await http
          .get('$amihubUrl/myCourses?semester=$semester');

      var jsonResponse = convert.jsonDecode(response.body);

      for (var item in jsonResponse) {
        Course course = Course.fromJson(item);
        course.semester = semester;
        courses.add(course);
        dbHelper.addCourse(course);
      }
      return courses;
    }

    return dbResponse;
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

  Future<void> logout(BuildContext context) async {
    SharedPreferences.getInstance().then((sp) {
      sp.remove('Authorization');
    });
    dbHelper.deleteDatabase().then((e) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }
}
