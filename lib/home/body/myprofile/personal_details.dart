import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PersonalDetails extends StatelessWidget {
  final String fatherName;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final String mobileNumber;
  final String email;
  final String contactAddress;
  final String permanentAddress;
  final String pinCode;

  PersonalDetails(
      {Key key,
      @required this.fatherName,
      @required this.dateOfBirth,
      @required this.phoneNumber,
      @required this.mobileNumber,
      @required this.email,
      @required this.contactAddress,
      @required this.permanentAddress,
        @required this.pinCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(dateOfBirth);
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Text("Personal Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        PersonalDetail(
          profileKey: "Father's Name",
          profileValue: fatherName,
        ),
        PersonalDetail(
          profileKey: "Date of birth",
          profileValue: "${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}",
        ),
        PersonalDetail(
          profileKey: "Phone Number",
          profileValue: phoneNumber,
        ),
        PersonalDetail(
          profileKey: "Mobile Number",
          profileValue: mobileNumber,
        ),
        PersonalDetail(
          profileKey: "Email",
          profileValue: email,
        ),
        PersonalDetail(
          profileKey: "Contact Address",
          profileValue: contactAddress,
        ),
        PersonalDetail(
          profileKey: "Permanent Address",
          profileValue: permanentAddress,
        ),
        PersonalDetail(
          profileKey: "Pincode",
          profileValue: pinCode,
        ),Divider(),
      ],
    );
  }
}

class PersonalDetail extends StatelessWidget {
  final String profileKey;
  final String profileValue;

  PersonalDetail(
      {Key key, @required this.profileKey, @required this.profileValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(title: Text(profileKey),subtitle: Text(profileValue),),
      ],
    );


  }
}
