import 'package:amihub/forgot_password.dart';
import 'package:amihub/home_backdrop.dart';
import 'package:amihub/load.dart';
import 'package:amihub/login.dart';
import 'package:amihub/splash_screen.dart';
import 'package:flutter/material.dart';

import '../captcha_page.dart';


//Make Splash Screen home
Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/home': (BuildContext context) => Home(),
  '/captcha': (BuildContext context) => CaptchaPageNew(),
  '/forgotPassword': (BuildContext context) => ForgotPassword(),
  '/load': (BuildContext context) => LoadApi(),
  '/login': (BuildContext context) => LoginPage(),
};
