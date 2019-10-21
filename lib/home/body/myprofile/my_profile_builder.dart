import 'package:amihub/components/page_heading.dart';
import 'package:amihub/home/body/myprofile/personal_details.dart';
import 'package:amihub/home/body/myprofile/profile_Icon.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'academic_details.dart';

class MyProfileBuilder extends StatefulWidget {
  @override
  _MyProfileBuilderState createState() => _MyProfileBuilderState();
}

class _MyProfileBuilderState extends State<MyProfileBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: amizoneRepository.fetchMyProfile(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null)
              return Center(child: Text('Could Not Fetch Your Profile'));

            return Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PageHeader("My Profile"),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        ProfileIcon(
                          imageLink: snapshot.data['photo'],
                          name: snapshot.data['name'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 20, right: 20),
                          child: AcademicDetails(
                            batch: snapshot.data['batch'].toString(),
                            enrollmentNumber:
                                snapshot.data['enrollmentNo'].toString(),
                            program: snapshot.data['program'].toString(),
                            semester: snapshot.data['semester'].toString(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 20, right: 20),
                          child: PersonalDetails(
                            dateOfBirth: DateFormat.yMMMMd("en_US").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data['dob'],
                                    isUtc: false)),
                            email: snapshot.data['email'].toString(),
                            phoneNumber: snapshot.data['phone'].toString(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                              child: Text(
                            "error? contact support@amihub.com",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(" "); // unreachable
      },
    );
  }
}
