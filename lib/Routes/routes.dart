import 'package:amihub/captcha.dart';
import 'package:amihub/login.dart';
import 'package:amihub/main.dart';
import 'package:amihub/unnamed.dart';
import 'package:flutter/material.dart';



Route<dynamic> generateRoute(RouteSettings settings) {

  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => MyApp());
    case 'login':
      return MaterialPageRoute(builder: (context) => LoginPage());
    case 'captcha':
      return MaterialPageRoute(builder: (context) => CaptchaPage());
    default:
      return MaterialPageRoute(builder: (context)=>UnnamedPage());
  }

}