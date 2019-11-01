import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: blackOrWhite(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/error.png',
                height: width * 0.5, width: width * 0.5),
            SizedBox(
              height: 20,
            ),
            Text(
              'Oopsie !',
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Something doesn't seem Kosher \nabout these pigs",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
