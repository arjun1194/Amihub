import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';
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
      if (sharedPreferences.containsKey('Authorization') && checkAuthValid()) {
        print('<---JWt is valid : logging you in --->\n\n\n');
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
      body: Container(
        color: greenMain,
        height: double.infinity,
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Amihub', style: TextStyle(color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold),),
            Text('attendance tracking system for Amity University',
              style: TextStyle(color: Colors.white, fontSize: 20),)
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
