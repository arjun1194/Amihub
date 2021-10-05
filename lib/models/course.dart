class Course {
  String courseCode;
  String courseName;
  String type;
  String syllabus;
  int courseId;
  int present;
  int total;
  String percentage;
  String internalAssessment;
  int semester;

  Course(
      {this.courseCode,
      this.courseName,
      this.type,
      this.syllabus,
      this.courseId,
      this.present,
      this.total,
      this.percentage,
      this.internalAssessment,
      this.semester});

  Course.fromJson(Map<String, dynamic> json) {
    courseCode = json['courseCode'];
    courseName = json['courseName'];
    type = json['type'];
    syllabus = json['syllabus'];
    courseId = json['courseId'];
    present = json['present'];
    total = json['total'];
    percentage = json['percentage'].toString();
    internalAssessment = json['internalAssessment'];
    semester = json['semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseCode'] = this.courseCode;
    data['courseName'] = this.courseName;
    data['type'] = this.type;
    data['syllabus'] = this.syllabus;
    data['courseId'] = this.courseId;
    data['present'] = this.present;
    data['total'] = this.total;
    data['percentage'] = this.percentage;
    data['internalAssessment'] = this.internalAssessment;
    data['semester'] = this.semester;
    return data;
  }



  @override
  String toString() {
    return 'Course{courseCode: $courseCode, courseName: $courseName, type: $type, syllabus: $syllabus, courseId: $courseId, present: $present, total: $total, percentage: $percentage, internalAssessment: $internalAssessment, semester: $semester}';
  }


}
