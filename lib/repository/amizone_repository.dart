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
    if (dbResponse.isEmpty) {
      Map data = await networkCallMetadata();
      return data['attendance'];
    }
    return dbResponse;
  }

  Future<Score> fetchScoreWithSemester(int semester) async {
    Score dbResponse = await dbHelper.getScoreWithSemester(semester);
    Score dbResponseMinusOne;
    if (dbResponse == null)
      dbResponseMinusOne = await dbHelper.getScoreWithSemester(semester - 1);
    if (dbResponse == null && dbResponseMinusOne == null) {
      Map data = await networkCallMetadata();
      List<Score> scores = data['score'];
      return scores.firstWhere((score) => score.semester == semester);
    }
    if (dbResponse == null && dbResponseMinusOne != null)
      return Score(cgpa: 0.0, sgpa: 0.0);

    return dbResponse;
  }

  Future<List<Score>> fetchCurrentScore() async {
    List<Score> dbResponse = await dbHelper.getScore();
    if (dbResponse.isEmpty) {
      Map data = await networkCallMetadata();
      return data['score'];
    }
    return dbResponse;
  }

  Future<Map> networkCallMetadata() async {

    HttpWithInterceptor http =
    HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/metadata');
    var jsonResponse = convert.jsonDecode(response.body);

    /// Saving semester and enrollNo in SharedPref
    SharedPreferences.getInstance().then((sp) {
      sp.setInt("semester", jsonResponse['semester']);
      sp.setString("enrollNo", jsonResponse['enrollmentNumber']);
    });

    /// Parsing scores
    List<Score> scores = [];
    for (var item in jsonResponse['results']){
      Score score = Score.fromJson(item);
      scores.add(score);
      dbHelper.addGpa(score);
    }

    /// Parsing attendance
    List<CourseAttendance> courseAttendance = [];
    for (var elements in jsonResponse['attendance']) {
      String perc = elements['percentage'].toString();
      courseAttendance.add(CourseAttendance(elements['courseName'],
          double.tryParse(perc.substring(0, perc.indexOf("%")))));
    }

    List<CourseAttendanceType> list = [
      CourseAttendanceType(attendanceType: "BELOW_75", noOfCourses: 0),
      CourseAttendanceType(
          attendanceType: "BETWEEN_75_TO_85", noOfCourses: 0),
      CourseAttendanceType(attendanceType: "ABOVE_85", noOfCourses: 0)
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

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("lastTimeMetadataUpdated", DateTime.now().toString());

    Map data = Map();
    data["score"] = scores;
    data["attendance"] = list;
    return data;
  }

  Future<List<CourseResult>> fetchResultsWithSemester(int semester) async {
    List<CourseResult> dbResponse =
        await dbHelper.getResultWithSemester(semester);
    List<CourseResult> results = [];
    if (dbResponse.isEmpty) {
      HttpWithInterceptor http =
          HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
      var response = await http.get('$amihubUrl/result?semester=$semester');
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse.length == 1) {
        CourseResult courseResult = CourseResult.fromJson(jsonResponse[0]);
        if (courseResult.courseTitle == "") return [courseResult];
      }
      for (var item in jsonResponse) {
        CourseResult courseResult = CourseResult.fromJson(item);
        courseResult.semester = semester;
        dbHelper.addCourseResult(courseResult);
        results.add(courseResult);
      }
      return results;
    }
    return dbResponse;
  }

  Future<List<TodayClass>> fetchTodayClass() async {
    String date = DateFormat("MM/dd/yyyy").format(DateTime.now());
    return fetchTodayClassWithDate(date, date);
  }

  Future<List<TodayClass>> fetchTodayClassWithDate(
      String start, String end) async {
    List<TodayClass> dbResponse = await dbHelper.getTodayClassesWithDate(start);
    if (dbResponse.isEmpty) {
      return networkCallTodayClass(start);
    }
    return sortTodayClass(dbResponse);
  }

  Future<List<TodayClass>> networkCallTodayClass(String start) async {
    List<TodayClass> todayClass = [];
    start =
        DateFormat("yyyy-MM-dd").format(DateFormat("MM/dd/yyyy").parse(start));
    HttpWithInterceptor http =
        HttpWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response =
        await http.get('$amihubUrl/todayClass?start=$start&end=$start');
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse) {
      TodayClass td = TodayClass.fromJson(item);
      todayClass.add(td);
      dbHelper.addTodayClass(td);
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("lastTimeTCUpdated", DateTime.now().toString());
    return sortTodayClass(todayClass);
  }

  List<TodayClass> sortTodayClass(List<TodayClass> todayClass) {
    todayClass.sort((a, b) {
      DateTime date1 = DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(a.start);
      DateTime date2 = DateFormat("MM/dd/yyyy HH:mm:ss aaa").parse(b.start);
      return date1.isAfter(date2) ? 1 : -1;
    });
    return todayClass;
  }

  Future<Course> fetchCourseWithCourseName(String courseName) async {
    Course dbResponse = await dbHelper.getCourseWithCourseName(courseName);
    if (dbResponse == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      int semester = sharedPreferences.getInt('semester');
      List<Course> courses = await networkCallCourses(semester);
      return courses.firstWhere((course) => course.courseName == courseName);
    }
    return dbResponse;
  }

  Future<List<Course>> networkCallCourses(int semester) async {
    List<Course> courses = [];
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("lastTimeMCUpdated", DateTime.now().toString());
    return courses;
  }

  Future<List<Course>> fetchMyCoursesWithSemester(int semester) async {
    List<Course> dbResponse = await dbHelper.getCoursesWithSemester(semester);
    if (dbResponse.isEmpty) {
      return networkCallCourses(semester);
    }
    return dbResponse;
  }

  Future<List<Faculty>> fetchMyFaculty() async {
    HttpClientWithInterceptor http =
        HttpClientWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    var response = await http.get('$amihubUrl/faculty');
    var jsonResponse = convert.jsonDecode(response.body);
    List<Faculty> faculties = [];
    for (var item in jsonResponse) {
      Faculty faculty = Faculty.fromJson(item);
      faculties.add(faculty);
    }
    return faculties;
  }

  Future<List<Attendance>> fetchCourseAttendance(
      {@required int courseId}) async {
    HttpClientWithInterceptor http =
        HttpClientWithInterceptor.build(interceptors: [AmizoneInterceptor()]);
    List<Attendance> attendances = [];
    var response = await http.get('$amihubUrl/myCourses/attendance/$courseId');
    var jsonResponse = convert.jsonDecode(response.body);
    for (var item in jsonResponse) {
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
    String requestBody = '{"username":$username, "password":"$password"}';
    var headers = {"content-type": "application/json"};
    Response resp = await client.post(url, headers: headers, body: requestBody);

    return resp;
  }

  Future<void> logout(BuildContext context) async {
    ///clear shared preferences
    SharedPreferences.getInstance().then((sp) {
      sp.remove('Authorization');
      sp.remove('lastTimeMCUpdated');
      sp.remove('lastTimeMetadataUpdated');
      sp.remove('lastTimeTCUpdated');
      sp.remove('enrollNo');
      sp.remove('semester');

    });
    ///clear database
    dbHelper.deleteDatabase().then((e) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }
}
