import 'dart:convert';

class CourseResult {
  String courseCode;
  String courseTitle;
  int maxMarks;
  int associatedCreditUnits;
  String gradeObtained;
  int gradePoints;
  int creditPoints;
  int earnedCreditUnits;
  String publishDate;
  int semester;

  CourseResult({
    this.courseCode,
    this.courseTitle,
    this.maxMarks,
    this.associatedCreditUnits,
    this.gradeObtained,
    this.gradePoints,
    this.creditPoints,
    this.earnedCreditUnits,
    this.publishDate,
    this.semester,
  });

  factory CourseResult.fromJson(Map<String, dynamic> json) => CourseResult(
    courseCode: json["courseCode"],
    courseTitle: json["courseTitle"],
    maxMarks: json["maxMarks"],
    associatedCreditUnits: json["associatedCreditUnits"],
    gradeObtained: json["gradeObtained"],
    gradePoints: json["gradePoints"],
    creditPoints: json["creditPoints"],
    earnedCreditUnits: json["earnedCreditUnits"],
    publishDate: json["publishDate"],
    semester: json["semester"],
  );

  Map<String, dynamic> toJson() => {
    "courseCode": courseCode,
    "courseTitle": courseTitle,
    "maxMarks": maxMarks,
    "associatedCreditUnits": associatedCreditUnits,
    "gradeObtained": gradeObtained,
    "gradePoints": gradePoints,
    "creditPoints": creditPoints,
    "earnedCreditUnits": earnedCreditUnits,
    "publishDate": publishDate,
    "semester": semester,
  };
}
