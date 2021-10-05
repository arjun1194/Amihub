import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class UnderDevelopment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackOrWhite(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Coming soon',
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Under Development',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }


}
