import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sharedPreferences) {
      if (sharedPreferences.containsKey('Authorization')) {
        if (!sharedPreferences.getBool("appDown")) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
        } else {
          String message = sharedPreferences.getString("downMessage");
          Navigator.pushNamedAndRemoveUntil(
              context, '/down', (Route<dynamic> route) => false,
              arguments: message);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    return Center(
      child: Container(),
    );
  }

  bool checkAuthValid() {
    //TODO: implement this function
    return true;
  }

  bool checkVersionValid() {
    //TODO:implement this  function
    return true;
  }
}
