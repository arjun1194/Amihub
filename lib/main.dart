import 'package:amihub/Theme/theme.dart';
import 'package:amihub/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Application 1",home: LoginPage(),theme: ThemeData(accentColor: lightGreen),);
  }
}


