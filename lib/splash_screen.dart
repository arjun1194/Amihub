import 'package:flutter/material.dart';
import 'package:amihub/Theme/theme.dart';

List<Color> appList = [lightGreen, lighterGreen];

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 5), () => "1");
  }

  load() {
    sleep1();
//    var route = MaterialPageRoute(builder: (BuildContext context)=>LoginPage());
//    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.home,
                color: lightGreen,
                size: 200,
              ),
              Text(
                "Amihub",
                style: TextStyle(fontFamily: "Roboto", fontSize: 50),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        backgroundColor: lighterGreen,
                      ),
                    ),
                  ),
                  Text("Loading your Data...")
                ],
              )
            ],
          ))),
    );
  }
}
