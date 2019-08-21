import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      if (sharedPreferences.containsKey('Authorization') && checkAuthValid()) {
        print('<---JWT is detected--->');

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
    return Scaffold(
      body: Center(
        child: Image.asset("amihub.png"),
      ),
    );
  }

  bool checkAuthValid() {
    //TODO: implement this function
    return true;
  }

  bool CheckVersionValid() {
    //TODO:implement this  function
    return true;
  }
}
