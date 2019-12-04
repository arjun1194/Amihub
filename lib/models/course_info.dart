class CourseInfo {
  String courseCode;
  String courseName;
  String courseSyllabus;
  int semester;
  String courseType;
  int levelOfHardness;
  double averageAssessment;
  String programme;
  int noOfBacks;
  int noOfStudentsStudied;
  double averageGpa;
  List<Faculty> faculties;

  CourseInfo(
      {this.courseCode,
        this.courseName,
        this.courseSyllabus,
        this.semester,
        this.courseType,
        this.levelOfHardness,
        this.averageAssessment,
        this.programme,
        this.noOfBacks,
        this.noOfStudentsStudied,
        this.averageGpa,
        this.faculties});

  CourseInfo.fromJson(Map<String, dynamic> json) {
    courseCode = json['courseCode'];
    courseName = json['courseName'];
    courseSyllabus = json['courseSyllabus'];
    semester = json['semester'];
    courseType = json['courseType'];
    levelOfHardness = json['levelOfHardness'];
    averageAssessment = json['averageAssessment'];
    programme = json['programme'];
    noOfBacks = json['noOfBacks'];
    noOfStudentsStudied = json['noOfStudentsStudied'];
    averageGpa = json['averageGpa'];
    if (json['faculties'] != null) {
      faculties = new List<Faculty>();
      json['faculties'].forEach((v) {
        faculties.add(new Faculty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseCode'] = this.courseCode;
    data['courseName'] = this.courseName;
    data['courseSyllabus'] = this.courseSyllabus;
    data['semester'] = this.semester;
    data['courseType'] = this.courseType;
    data['levelOfHardness'] = this.levelOfHardness;
    data['averageAssessment'] = this.averageAssessment;
    data['programme'] = this.programme;
    data['noOfBacks'] = this.noOfBacks;
    data['noOfStudentsStudied'] = this.noOfStudentsStudied;
    data['averageGpa'] = this.averageGpa;
    if (this.faculties != null) {
      data['faculties'] = this.faculties.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'CourseInfo{courseCode: $courseCode, courseName: $courseName, courseSyllabus: $courseSyllabus, semester: $semester, courseType: $courseType, levelOfHardness: $levelOfHardness, averageAssessment: $averageAssessment, programme: $programme, noOfBacks: $noOfBacks, noOfStudentsStudied: $noOfStudentsStudied, averageGpa: $averageGpa, faculties: $faculties}';
  }


}

class Faculty {
  String name;
  String code;
  String photo;

  Faculty({this.name, this.code, this.photo});

  Faculty.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['photo'] = this.photo;
    return data;
  }

  @override
  String toString() {
    return 'Faculty{name: $name, code: $code, photo: $photo}';
  }


}