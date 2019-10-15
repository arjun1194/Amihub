class Score {
  int semester;
  double cgpa;
  double sgpa;

  Score({this.semester, this.cgpa, this.sgpa});

  Score.fromJson(Map<String, dynamic> json) {
    semester = json['semester'];
    cgpa = json['cgpa'];
    sgpa = json['sgpa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['semester'] = this.semester;
    data['cgpa'] = this.cgpa;
    data['sgpa'] = this.sgpa;
    return data;
  }

  @override
  String toString() {
    return 'Score{semester: $semester, cgpa: $cgpa, sgpa: $sgpa}';
  }


}
