class CourseAttendance {
  String courseName;
  double attendance;

  CourseAttendance(this.courseName, this.attendance);

  CourseAttendance.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    attendance = json['attendance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseName'] = this.courseName;
    data['attendance'] = this.attendance;
    return data;
  }
}
