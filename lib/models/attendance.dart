class Attendance {
  String date;
  String timing;
  int present;
  int absent;
  String remarks;

  Attendance({
    this.date,
    this.timing,
    this.present,
    this.absent,
    this.remarks,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    date: json["date"],
    timing: json["timing"],
    present: json["present"],
    absent: json["absent"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "timing": timing,
    "present": present,
    "absent": absent,
    "remarks": remarks,
  };

  @override
  String toString() {
    return 'Attendance{date: $date, timing: $timing, present: $present, absent: $absent, remarks: $remarks}';
  }


}
