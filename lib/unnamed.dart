import 'package:amihub/Components/appbar.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';

class UnnamedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Center(
      child: Scaffold(
        appBar: myAppbar,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "You dont have Network Bruh!",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54),
            ),
            Image.asset(
              "assets/grumpy1.png",
              width: 0.6 * width,
            ),
            FlatButton(
              child: Center(
                child:
                    Text("Go to Home", style: TextStyle(color: Colors.black54)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
