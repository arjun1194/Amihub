import 'package:amihub/Theme/theme.dart';
import 'package:amihub/login.dart';
import 'package:amihub/unnamed.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Application 1",home: UnnamedPage(),theme: ThemeData(accentColor: lightGreen),);
  }
}


