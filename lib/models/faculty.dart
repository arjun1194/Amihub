class Faculty {
  String courseCode;
  String courseName;
  String facultyImage;
  String facultyCode;
  String facultyName;

  Faculty({
    this.courseCode,
    this.courseName,
    this.facultyImage,
    this.facultyCode,
    this.facultyName,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
    courseCode: json["courseCode"],
    courseName: json["courseName"],
    facultyImage: json["facultyImage"],
    facultyName: json["facultyName"],
    facultyCode: json["facultyCode"],
  );

  Map<String, dynamic> toJson() => {
    "courseCode": courseCode,
    "courseName": courseName,
    "facultyImage": facultyImage,
    "facultyName": facultyName,
    "facultyCode": facultyCode
  };

}