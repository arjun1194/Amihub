import 'dart:convert' as convert;

import 'package:amihub/database/database_helper.dart';
import 'package:amihub/home/body/course/course_detail.dart';
import 'package:amihub/interceptors/amizone_http_interceptor.dart';
import 'package:amihub/models/attendance.dart';
import 'package:amihub/models/course.dart';
import 'package:amihub/models/course_attendance.dart';
import 'package:amihub/models/course_attendance_type.dart';
import 'package:amihub/models/result.dart';
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

  Future <Score> fetchCurrentScoreWithSemester(int semester) async {
    Score dbResponse = await dbHelper.getScoreWithSemester(semester);
    if (dbResponse == null) {
      HttpWithInterceptor http = HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response = await http.get('$amihubUrl/metadata');
      var jsonResponse = convert.jsonDecode(response.body);
      Score currentSemScore;
      for (var element in jsonResponse['results']) {
        Score score = Score.fromJson(element);
        if (score.semester == semester)
          currentSemScore = score;
        int sc = await dbHelper.addGpa(score);
      }
      return currentSemScore;
    }
    return dbResponse;
  }

  Future<List<Score>> fetchCurrentScore() async {
    List<Score> dbResponse = await dbHelper.getScore();
    //if database response is empty
    if (dbResponse.isEmpty) {
      //make a network call to the server
      HttpWithInterceptor http =
          HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      //save the response
      var response = await http.get('$amihubUrl/metadata');
      //convert response to json
      var jsonResponse = convert.jsonDecode(response.body);
      //save the 'semester' key from jsonResponse in SharedPreferences
      SharedPreferences.getInstance().then((sp){
        sp.setInt("semester", jsonResponse['semester']);
      });
      //we have to return a array of scores.so create an empty list of scores
      List<Score> courseAttendance = [];

      for (var element in jsonResponse['results']) {
        // do this for every element in results[] of jsonResponse
        //add the element results[0] from jsonResponse to fit 'Score' Dto
        Score score = Score.fromJson(element);
        //add element to courseAttendance
        courseAttendance.add(score);
        //add to database
        dbHelper.addGpa(score);
      }
      return courseAttendance;
    }
    return dbResponse;
  }

  Future<List<CourseResult>> fetchResultsWithSemester(int semester) async {
    List<CourseResult> results = [];
    HttpWithInterceptor http =
        HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/result?semester=$semester');
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse){
      results.add(CourseResult.fromJson(item));
    }
    return results;
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

  Future<Course> fetchCourseWithCourseName(String courseName) async {
    Course dbResponse = await dbHelper.getCourseWithCourseName(courseName);
    if (dbResponse == null) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      int semester = sharedPreferences.getInt('semester');
      List<Course> courses = await fetchCourseAndSave(semester);
      return courses.firstWhere((course) => course.courseName == courseName);
    }
    return dbResponse;
  }

  Future<List<Course>> fetchCourseAndSave(int semester)async{
    List<Course> courses =[];
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


  Future<List<Course>> fetchMyCoursesWithSemester(int semester) async {
    List<Course> dbResponse = await dbHelper.getCoursesWithSemester(semester);
    if (dbResponse.isEmpty) {
     return await fetchCourseAndSave(semester);
    }
    print('from db');
    return dbResponse;
  }

  Future<List<Faculty>> fetchMyFaculty() async {
    HttpClientWithInterceptor http = HttpClientWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/faculty');
    var jsonResponse = convert.jsonDecode(response.body);
    List<Faculty> faculties = [];
    for (var item in jsonResponse) {
      Faculty faculty = Faculty.fromJson(item);
      faculties.add(faculty);
    }
    return faculties;
  }

  Future<List<Attendance>> fetchCourseAttendance({@required int courseId}) async{
    HttpClientWithInterceptor http = HttpClientWithInterceptor.build(
      interceptors: [AmizoneInterceptor()]);
    List<Attendance> attendances = [];
    var response = await http.get('$amihubUrl/myCourses/attendance/$courseId');
    var jsonResponse = convert.jsonDecode(response.body);
    for( var item in jsonResponse){
      attendances.add(Attendance.fromJson(item));
    }
    return attendances;
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
