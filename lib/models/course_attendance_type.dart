class CourseAttendanceType{
  String attendanceType;
  int noOfCourses;

  CourseAttendanceType({this.attendanceType, this.noOfCourses});

  @override
  String toString() {
    return 'CourseAttendanceType{attendanceType: $attendanceType, noOfCourses: $noOfCourses}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendanceType'] = this.attendanceType;
    data['noOfCourses'] = this.noOfCourses;
    return data;
  }

  CourseAttendanceType.fromJson(Map<String, dynamic> json) {
    attendanceType = json['attendanceType'];
    noOfCourses = json['noOfCourses'];
  }

}
