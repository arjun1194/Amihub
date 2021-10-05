class TodayClass {
  String _color;
  String _courseCode;
  String _facultyName;
  String _roomNo;
  String _start;
  String _end;
  String _title;

  TodayClass(
      {String color,
      String courseCode,
      String facultyName,
      String roomNo,
      String start,
      String end,
      String title}) {
    this._color = color;
    this._courseCode = courseCode;
    this._facultyName = facultyName;
    this._roomNo = roomNo;
    this._start = start;
    this._end = end;
    this._title = title;
  }

  String get color => _color;

  set color(String color) => _color = color;

  String get courseCode => _courseCode;

  set courseCode(String courseCode) => _courseCode = courseCode;

  String get facultyName => _facultyName;

  set facultyName(String facultyName) => _facultyName = facultyName;

  String get roomNo => _roomNo;

  set roomNo(String roomNo) => _roomNo = roomNo;

  String get start => _start;

  set start(String start) => _start = start;

  String get end => _end;

  set end(String end) => _end = end;

  String get title => _title;

  set title(String title) => _title = title;

  TodayClass.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _color = json['color'];
    _courseCode = json['courseCode'];
    _facultyName = json['facultyName'];
    _roomNo = json['roomNo'];
    _start = correctDate(json['start']);
    _end = _title != "" ? correctDate(json['end']) : json['end'];
  }

  String correctDate(String before) {
    List<String> as = before.toString().split("/");
    bool lessThanTen = as[1].length == 1;
    if (lessThanTen) {
      as[1] = '0${as[1]}';
    }
    if (as[0].length == 1) as[0] = '0${as[0]}';
    return as.join("/");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this._color;
    data['courseCode'] = this._courseCode;
    data['facultyName'] = this._facultyName;
    data['roomNo'] = this._roomNo;
    data['start'] = this._start;
    data['end'] = this._end;
    data['title'] = this._title;
    return data;
  }

  @override
  String toString() {
    return 'TodayClass{_color: $_color, _courseCode: $_courseCode, _facultyName: $_facultyName, _roomNo: $_roomNo, _start: $_start, _end: $_end, _title: $_title}';
  }
}
