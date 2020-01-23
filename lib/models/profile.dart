class Profile {
  String enrollmentNumber;
  String program;
  String batch;
  String semester;
  String dateOfBirth;
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
    enrollmentNumber = json['enrollmentNo'].toString();
    program = json['program'].toString();
    batch = json['batch'].toString();
    semester = json['semester'].toString();
    dateOfBirth = json['dob'].toString();
    phoneNumber = json['phone'].toString();
    email = json['email'].toString();
    photo = json['photo'].toString();
    name = json['name'].toString();
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