import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                : FacultyDetailBuild(
                    snapshot: snapshot,
                  );
        }
        return Text('end');
      },
    ));
  }
}

class FacultyDetailBuild extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;

  FacultyDetailBuild({Key key, @required this.snapshot}) : super(key: key);

  /*{
      facultyCode: 7310,
      facultyImage: https://amizone.net/AdminAmizone/images/StaffImages/7310_p.png,
      facultyName: Ms Anjali Jain,
      email: null,
      phoneNo: null,
      cabin: null,
      designation: null,
      department: Amity School of Engineering and Technology,
      courses: [
        {
          code: ES103,
          name: Basic Electrical Engineering,
          semester: 2
        },
        {
          code: ELEC411,
          name: Utilization of Electrical Energy,
          semester: 8
        }
          ]
     }*/

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.blue,
          expandedHeight: 250,
          floating: false,
          pinned: true,
          actions: <Widget>[IconButton(icon: Icon(Icons.more_vert), onPressed: ()=>{print('hey')})],
          flexibleSpace: FlexibleSpaceBar(
            title: Container(color: Colors.red,child: Text('Hello'),),
            background: Container(color:Colors.green,child: Icon(Icons.account_circle),),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) => ListTile(title: Text('Element $index'),)),
        )
      ],
    );
  }
}
