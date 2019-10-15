import 'dart:convert' as convert;

import 'package:amihub/database/database_helper.dart';
import 'package:amihub/interceptors/amizone_http_interceptor.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/models/course_attendance.dart';
import 'package:amihub/models/course_attendance_type.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/models/today_class.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmizoneRepository {
  DatabaseHelper dbHelper = DatabaseHelper.db;

  Future<List<CourseAttendanceType>> fetchCurrentAttendance() async {
    List<CourseAttendanceType> dbResponse = await dbHelper.getCourseType();
    if (dbResponse.isEmpty){
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

      List<CourseAttendanceType> list = [
        CourseAttendanceType(
            attendanceType: "BELOW_75", noOfCourses: 0),
        CourseAttendanceType(
            attendanceType: "BETWEEN_75_TO_85", noOfCourses: 0),
        CourseAttendanceType(
            attendanceType: "ABOVE_85", noOfCourses: 0)
      ];

      courseAttendance.forEach((course) {
        if (course.attendance < 75) {
          list.elementAt(0).noOfCourses += 1;
        } else if (course.attendance >= 75 && course.attendance < 85) {
          list.elementAt(1).noOfCourses += 1;
        } else {
          list.elementAt(2).noOfCourses += 1;
        }
      });
      list.forEach((f) => dbHelper.addCourseAttendance(f));
      return list;
    }
    return dbResponse;

  }



  Future<List<Score>> fetchCurrentScore() async {
    List<Score> dbResponse = await dbHelper.getScore();
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http =
          HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response = await http.get('$amihubUrl/metadata');
      var jsonResponse = convert.jsonDecode(response.body);
      List<Score> courseAttendance = [];
      for (var element in jsonResponse['results']) {
        Score score = Score.fromJson(element);
        courseAttendance.add(score);
        dbHelper.addGpa(score);
      }
      return courseAttendance;
    }
    return dbResponse;
  }

  Future<List<dynamic>> fetchResultsWithSemester(int semester) async {
    HttpWithInterceptor http =
        HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/result?semester=$semester');
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  Future<List<TodayClass>> fetchTodayClass() async {
    String date = DateFormat("MM/dd/yyyy").format(DateTime.now());
    return fetchTodayClassWithDate(date, date);
  }

  Future<List<TodayClass>> fetchTodayClassWithDate(
      String start, String end) async {
    List<TodayClass> dbResponse = await dbHelper.getTodayClassesWithDate(start);
    List<TodayClass> todayClass = [];
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http =
          HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response =
          await http.get('$amihubUrl/todayClass?start=$start&end=$end');
      var jsonResponse = convert.jsonDecode(response.body);
      for (var item in jsonResponse) {
        TodayClass td = TodayClass.fromJson(item);
        todayClass.add(td);
        dbHelper.addTodayClass(td);
      }
      return todayClass;
    }
    return dbResponse;
  }

  Future<List<Course>> fetchMyCoursesWithSemester(int semester) async {
    print("Network");
    List<Course> dbResponse = await dbHelper.getCourseWithSemester(semester);
    List<Course> courses = [];
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http =
          HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response = await http.get('$amihubUrl/myCourses?semester=$semester');

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

  Future<Response> loginWithCaptcha(
      String username, String password, String gcaptcha) async {
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
