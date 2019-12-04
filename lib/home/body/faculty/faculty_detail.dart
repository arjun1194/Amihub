import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';

class FacultyDetail extends StatefulWidget {
  final String facultyCode;
  final String facultyName;

  FacultyDetail({@required this.facultyCode, @required this.facultyName});

  @override
  _FacultyDetailState createState() => _FacultyDetailState();
}

class _FacultyDetailState extends State<FacultyDetail> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(widget.facultyName),
        body: FutureBuilder(
          future: amizoneRepository.getFacultyInfo(widget.facultyCode),
          builder: (context, AsyncSnapshot<FacultyInfo> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Loader();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return (snapshot.hasError || snapshot.data == null)
                    ? Padding(
                        child: ErrorPage(),
                        padding: EdgeInsets.only(top: 50),
                      )
                      //TODO: add these
                      /**
                       * email
                       * phone
                       * designation
                       * cabin
                       * department
                       * image
                       * name
                       * courses
                       */
                    : Text(snapshot.data.department);
            }
            return Text('end');
          },
        ));
  }
}
