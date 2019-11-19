class Profile {
  String enrollmentNumber;
  String program;
  String batch;
  int semester;
  int dateOfBirth;
  String phoneNumber;
  String email;
  String photo;
  String name;

  Profile(
      {this.enrollmentNumber,
        this.program,
        this.batch,
        this.semester,
        this.dateOfBirth,
        this.phoneNumber,
        this.email,
        this.photo,
        this.name});

  Profile.fromJson(Map<String, dynamic> json) {
    enrollmentNumber = json['enrollmentNumber'];
    program = json['program'];
    batch = json['batch'];
    semester = int.tryParse(json['semester']);
    dateOfBirth = int.tryParse(json['dateOfBirth']);
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    photo = json['photo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enrollmentNumber'] = this.enrollmentNumber;
    data['program'] = this.program;
    data['batch'] = this.batch;
    data['semester'] = this.semester;
    data['dateOfBirth'] = this.dateOfBirth;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['name'] = this.name;
    return data;
  }
}