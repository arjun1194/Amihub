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
    var width = MediaQuery.of(context).size.width;
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
                          expandedHeight:
                              MediaQuery.of(context).size.width * 0.8,
                          pinned: true,
                          actions: <Widget>[
                            IconButton(
                                icon: Icon(Icons.more_vert), onPressed: () {})
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.none,
                            background: Container(
                              margin: EdgeInsets.fromLTRB(width * 0.05,
                                  width * 0.25, width * 0.05, width * 0.1),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        snapshot.data.facultyImage,
                                        width: 180,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.facultyName,
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.mail),
                                                onPressed: () {
                                                  launch(
                                                      "mailto:${snapshot.data.email}");
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.call),
                                                onPressed: () {
                                                  launch(
                                                      "tel:${snapshot.data.phoneNo}");
                                                },
                                              ),
                                            ],
                                          ),
                                          snapshot.data.cabin != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    snapshot.data.cabin,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        snapshot.data.designation != null
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Chip(
                                    label: Text(snapshot.data.designation)),
                              )
                            : Container(),
                        snapshot.data.department != null
                            ? Chip(
                                label: Text(
                                  snapshot.data.department,
                                  style: TextStyle(),
                                ),
                              )
                            : Container(),
                        snapshot.data.courses.length != 0
                            ? PageHeader('Courses')
                            : Container(),
                        snapshot.data.courses.length != 0
                            ? Container(
                                padding: EdgeInsets.all(10),
                                child: Wrap(
                                    children:
                                        snapshot.data.courses.map((course) {
                                  return InkWell(
                                    onTap: () {
//                                      CustomPageRoute.pushPage(context: context, child: CoursePage(course: ,))
                                    },
                                    child: Container(
                                      decoration: ShapeDecoration(
                                          color: Color(0xff121212),
                                          shape: StadiumBorder()),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 8, 12, 8),
                                        child: Text(
                                          course.name,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()),
                              )
                            : Container(),
                      ]))
                    ],
                  );
        }
        return Text('end');
      },
    ));
  }
}
