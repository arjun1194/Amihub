import 'package:amihub/components/app_down.dart';
import 'package:amihub/forgot_password.dart';
import 'package:amihub/home_backdrop.dart';
import 'package:amihub/load.dart';
import 'package:amihub/login.dart';
import 'package:amihub/models/backdrop_selected.dart';
import 'package:amihub/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Make Splash Screen home
Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/home': (BuildContext context) => ChangeNotifierProvider(
      builder: (context) => BackdropSelected(), child: Home()),
//  '/captcha': (BuildContext context) => CaptchaPageNew(),
  '/forgotPassword': (BuildContext context) => ForgotPassword(),
  '/load': (BuildContext context) => LoadApi(),
  '/login': (BuildContext context) => LoginPage(),
  '/down': (BuildContext context) => AppDown(),
};
