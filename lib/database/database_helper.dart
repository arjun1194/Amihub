import 'dart:async';
import 'dart:io';

import 'package:amihub/models/course.dart';
import 'package:amihub/models/course_attendance_type.dart';
import 'package:amihub/models/result.dart';
import 'package:amihub/models/score.dart';
import 'package:amihub/models/today_class.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    String _path  = await getDatabasesPath();
    String path = join(_path, "amihub.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          
          CREATE TABLE todayClass(
           color TEXT NOT NULL,
           courseCode TEXT NOT NULL,
           facultyName TEXT NOT NULL,
           roomNo TEXT NOT NULL,
           start TEXT PRIMARY KEY,
           end TEXT NOT NULL,
           title TEXT NOT NULL
          )''');

      await db.execute('''
          
          CREATE TABLE course(
           courseCode TEXT NOT NULL,
           courseName TEXT NOT NULL,
           type TEXT NOT NULL,
           syllabus TEXT,
           courseId INTEGER PRIMARY KEY,
           present INTEGER,
           total INTEGER,
           percentage TEXT,
           internalAssessment TEXT,
           semester INTEGER NOT NULL
          )''');

      await db.execute('''
      
          CREATE TABLE courseResult(
            courseCode TEXT NOT NULL PRIMARY KEY,
            courseTitle TEXT NOT NULL,
            maxMarks INTEGER,  
            associatedCreditUnits INTEGER,  
            gradeObtained TEXT, 
            gradePoints INTEGER, 
            creditPoints INTEGER,  
            earnedCreditUnits INTEGER,
            publishDate TEXT,
            semester INTEGER NOT NULL

          )''');

      await db.execute('''
         CREATE TABLE gpa(
           semester INTEGER PRIMARY KEY,
           cgpa REAL NOT NULL,
           sgpa REAL NOT NULL
         )''');

      await db.execute('''
         CREATE TABLE courseAttendance(
           attendanceType TEXT PRIMARY KEY,
           noOfCourses INTEGER
         )''');
      // TODO : Please add delete query on adding a table
      await db.rawQuery("PRAGMA table_info(course);");
    });
  }

  addCourseAttendance(CourseAttendanceType courseAttendanceType) async {
    final db = await database;
    var raw = await db.insert("courseAttendance", courseAttendanceType.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  addCourseResult(CourseResult courseResult) async {
    final db = await database;
    var raw = await db.insert("courseResult", courseResult.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  addGpa(Score score) async {
    final db = await database;
    var raw = await db.insert("gpa", score.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  addTodayClass(TodayClass todayClass) async {
    final db = await database;
    var raw = await db.insert(
      "todayClass",
      todayClass.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  addCourse(Course course) async {
    final db = await database;
    var raw = await db.insert(
      "course",
      course.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<Score> getScoreWithSemester(int semester) async {
    final db = await database;
    String sql = "SELECT * FROM gpa WHERE semester=$semester";
    var response = await db.rawQuery(sql);
    return (response.isEmpty) ? null : Score.fromJson(response.elementAt(0));
  }

  Future<List<CourseResult>> getResultWithSemester(int semester) async {
    final db = await database;
    String sql = "SELECT * FROM courseResult WHERE semester = $semester";
    var response = await db.rawQuery(sql);
    return response.map((cr) => CourseResult.fromJson(cr)).toList();
  }

  Future<List<Score>> getScore() async {
    final db = await database;
    String sql = "SELECT * FROM gpa";
    var response = await db.rawQuery(sql);
    List<Score> list = response.map((c) => Score.fromJson(c)).toList();
    return list;
  }

  Future deleteTodayClassesWithDate(String date) async {
    final db = await database;
    String sql = "DELETE FROM todayClass WHERE start LIKE '$date%'";
    var response = await db.rawQuery(sql);
    return response;
  }

  Future deleteGpa() async {
    final db = await database;
    String sql = "DELETE * FROM gpa";
    var response = await db.rawQuery(sql);
    return response;
  }

  Future deleteCourseAttendance() async {
    final db = await database;
    String sql = "DELETE * FROM courseAttendance";
    var response = db.rawQuery(sql);
    return response;
  }

  Future deleteResult() async {
    final db = await database;
    String sql = "DELETE * FROM courseResult";
    var response = db.rawQuery(sql);
    return response;
  }

  Future deleteCourseWithSemester(int semester) async {
    final db = await database;
    String sql = "DELETE FROM course WHERE semester = $semester";
    var response = await db.rawQuery(sql);
    return response;
  }

  Future<List<TodayClass>> getTodayClassesWithDate(String date) async {
    final db = await database;
    String sql = "SELECT * FROM todayClass WHERE start LIKE '$date%'";
    var response = await db.rawQuery(sql);
    List<TodayClass> list =
        response.map((c) => TodayClass.fromJson(c)).toList();
    return list;
  }

  Future<List<Course>> getCoursesWithSemester(int semester) async {
    final db = await database;
    String sql = "SELECT * FROM course WHERE semester = $semester";
    var response = await db.rawQuery(sql);
    List<Course> list = response.map((c) => Course.fromJson(c)).toList();
    return list;
  }

  Future<Course> getCourseWithCourseName(String courseName) async {
    final db = await database;
    String sql = "SELECT * FROM course WHERE courseName LIKE '$courseName'";
    var response = await db.rawQuery(sql);
    List<Course> courses = response.map((c) => Course.fromJson(c)).toList();
    return courses.first;
  }

  Future<List<CourseAttendanceType>> getCourseType() async {
    final db = await database;
    String sql = "SELECT * FROM courseAttendance";
    var response = await db.rawQuery(sql);
    List<CourseAttendanceType> list =
        response.map((c) => CourseAttendanceType.fromJson(c)).toList();
    return list;
  }

  Future<void> deleteDatabase() async {
    final db = await database;
    String sql = "DELETE FROM course";
    String sql2 = "DELETE FROM todayClass";
    String sql3 = "DELETE FROM gpa";
    String sql4 = "DELETE FROM courseAttendance";
    String sql5 = "DELETE FROM courseResult";

    await db.rawQuery(sql);
    await db.rawQuery(sql2);
    await db.rawQuery(sql3);
    await db.rawQuery(sql4);
    await db.rawQuery(sql5);
  }
}
