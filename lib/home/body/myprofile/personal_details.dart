import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PersonalDetails extends StatelessWidget {
  final String dateOfBirth;
  final String phoneNumber;
  final String email;

  PersonalDetails({
    Key key,
    @required this.dateOfBirth,
    @required this.phoneNumber,
    @required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Text(
          "Personal Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        PersonalDetail(
          profileKey: "Date of birth",
          profileValue: dateOfBirth,
        ),
        PersonalDetail(
          profileKey: "Phone Number",
          profileValue: phoneNumber,
        ),
        PersonalDetail(
          profileKey: "Email",
          profileValue: email,
        ),
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
        ListTile(
          title: Text(profileKey),
          subtitle: Text(profileValue),
        ),
        Divider(),
      ],
    );
  }
}
