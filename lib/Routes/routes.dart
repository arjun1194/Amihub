import 'package:amihub/captcha.dart';
import 'package:amihub/forgot_password.dart';
import 'package:amihub/home.dart';
import 'package:amihub/load.dart';
import 'package:amihub/login.dart';
import 'package:amihub/main.dart';
import 'package:flutter/material.dart';

import '../captcha_page.dart';

Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => MyApp(),
  '/captcha': (BuildContext context) => CaptchaPageNew(),
  '/forgotPassword': (BuildContext context) => ForgotPassword(),
  '/load': (BuildContext context) => LoadApi(),
  '/homepage': (BuildContext context) => HomePage(),
};
