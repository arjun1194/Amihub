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
  };
}
