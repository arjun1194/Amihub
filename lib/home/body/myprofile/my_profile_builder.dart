import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/home/body/myprofile/academic_details.dart';
import 'package:amihub/home/body/myprofile/personal_details.dart';
import 'package:amihub/home/body/myprofile/profile_Icon.dart';
import 'package:amihub/models/profile.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MyProfileBuilder extends StatefulWidget {
  @override
  _MyProfileBuilderState createState() => _MyProfileBuilderState();
}

class _MyProfileBuilderState extends State<MyProfileBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: amizoneRepository.fetchMyProfile(),
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              color: isLight(context)
                      ? Colors.white
                      : Colors.black,
              child: Center(
                child: Loader(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null)
              return ErrorPage();

            return Container(
              color: isLight(context)
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
                          imageLink: snapshot.data.photo,
                          name: snapshot.data.name,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 20, right: 20),
                          child: AcademicDetails(
                            batch: snapshot.data.batch,
                            enrollmentNumber:
                                snapshot.data.enrollmentNumber,
                            program: snapshot.data.program,
                            semester: snapshot.data.semester.toString(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 20, right: 20),
                          child: PersonalDetails(
                            dateOfBirth: DateFormat.yMMMMd("en_US").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.tryParse(snapshot.data.dateOfBirth),
                                    isUtc: false)),
                            email: snapshot.data.email,
                            phoneNumber: snapshot.data.phoneNumber,
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
