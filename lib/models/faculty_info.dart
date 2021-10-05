
class FacultyInfo {
  String facultyCode;
  String facultyImage;
  String facultyName;
  String email;
  String phoneNo;
  String cabin;
  String designation;
  String department;
  List<Course> courses;

  FacultyInfo({
    this.facultyCode,
    this.facultyImage,
    this.facultyName,
    this.email,
    this.phoneNo,
    this.cabin,
    this.designation,
    this.department,
    this.courses,
  });

  factory FacultyInfo.fromJson(Map<String, dynamic> json) => FacultyInfo(
    facultyCode: json["facultyCode"],
    facultyImage: json["facultyImage"],
    facultyName: json["facultyName"],
    email: json["email"],
    phoneNo: json["phoneNo"],
    cabin: json["cabin"],
    designation: json["designation"],
    department: json["department"],
    courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "facultyCode": facultyCode,
    "facultyImage": facultyImage,
    "facultyName": facultyName,
    "email": email,
    "phoneNo": phoneNo,
    "cabin": cabin,
    "designation": designation,
    "department": department,
    "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
  };
}

class Course {
  String code;
  String name;
  int semester;

  Course({
    this.code,
    this.name,
    this.semester,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    code: json["code"],
    name: json["name"],
    semester: json["semester"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "semester": semester,
  };
}
