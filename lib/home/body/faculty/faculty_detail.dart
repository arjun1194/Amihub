import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
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
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight: MediaQuery.of(context).size.width,
                        forceElevated: false,
                        floating: false,
                        pinned: true,
                        backgroundColor: greyMain,
                        flexibleSpace: new FlexibleSpaceBar(
                          title: Text(
                            snapshot.data.facultyName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          background: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.network(
                                snapshot.data.facultyImage,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(delegate: SliverChildListDelegate([
                        Container(
                          height: 1000,
                        )
                      ]))
                    ],
                  );
        }
        return Text('end');
      },
    ));
  }
}
