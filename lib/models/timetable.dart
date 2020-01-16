
class TimeTable {
  String day;
  List<Class> classes;

  TimeTable({
    this.day,
    this.classes,
  });

  factory TimeTable.fromJson(Map<String, dynamic> json) => TimeTable(
    day: json["day"],
    classes: List<Class>.from(json["classes"].map((x) => Class.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "classes": List<dynamic>.from(classes.map((x) => x.toJson())),
  };
}

class Class {
  String courseCode;
  String time;
  List<String> teachers;
  String room;

  Class({
    this.courseCode,
    this.time,
    this.teachers,
    this.room,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
    courseCode: json["courseCode"],
    time: json["time"],
    teachers: List<String>.from(json["teachers"].map((x) => x)),
    room: json["room"],
  );

  Map<String, dynamic> toJson() => {
    "courseCode": courseCode,
    "time": time,
    "teachers": List<dynamic>.from(teachers.map((x) => x)),
    "room": room,
  };
}
