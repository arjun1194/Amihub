import 'package:amihub/Home/Body/myprofile/personal_details.dart';
import 'package:amihub/Home/Body/myprofile/profile_Icon.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/material.dart';

import 'academic_details.dart';

class MyProfileBuilder extends StatefulWidget {
  @override
  _MyProfileBuilderState createState() => _MyProfileBuilderState();
}

class _MyProfileBuilderState extends State<MyProfileBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<dynamic>(
      future:
      amizoneRepository.fetchMyProfile(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null) return Center(child: Text('Could Not Fetch Your Profile'));

            return  ListView(padding: EdgeInsets.all(32),
              children: <Widget>[
                Text(
                  "My Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                ProfileIcon(
                  imageLink: snapshot.data['photo'],
                  name: snapshot.data['name'],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: AcademicDetails(batch: snapshot.data['batch'].toString(),enrollmentNumber: snapshot.data['enrollmentNo'].toString(),program: snapshot.data['program'].toString(),semester: snapshot.data['semester'].toString(),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: PersonalDetails(
                              contactAddress: snapshot.data['contactAddress'].toString(),
                              dateOfBirth: DateTime.fromMillisecondsSinceEpoch(snapshot.data['dob'],isUtc: false),
                              email: snapshot.data['email'].toString(),
                              fatherName: snapshot.data['fatherName'].toString(),
                              mobileNumber: snapshot.data['mobile'].toString(),
                              permanentAddress: snapshot.data['permanentAddress'].toString(),
                              phoneNumber: snapshot.data['phone'].toString(),
                              pincode: snapshot.data['pinCode'].toString(),
                  ),
                ),
                Center(child: Text("In case of discrepancy contact support@amihub.com",style: TextStyle(fontSize: 14,color: Colors.grey),)),
              ],
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
