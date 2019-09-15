import 'package:amihub/Home/Body/myprofile/my_profile_builder.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/material.dart';



class HomeMyProfile extends StatefulWidget {
  @override
  _HomeMyProfileState createState() => _HomeMyProfileState();
}

class _HomeMyProfileState extends State<HomeMyProfile> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  @override
  Widget build(BuildContext context) {
    return MyProfileBuilder();
  }
}





