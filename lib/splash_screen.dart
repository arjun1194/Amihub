import 'package:amihub/theme/theme.dart';
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
    Future.delayed(Duration(seconds: 2));
    SharedPreferences.getInstance().then((sharedPreferences) {
      if (sharedPreferences.containsKey('Authorization') && checkAuthValid()) {
        print('<---JWt is valid : logging you in --->');
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      } else {
        print("invalid JWT or JWT expired");
        if (sharedPreferences.containsKey('Authorization'))
          sharedPreferences.remove('Authorization');
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
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/amihub.png",
              height: 90,
              width: 90,
            ),
            SizedBox(height: 25,),
            Text(
              appTitle,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "OpenSans",
                  fontSize: 28,
                  ),
            ),
          ],
        ),
      ),
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
