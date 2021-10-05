import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDown extends StatefulWidget {
  @override
  _AppDownState createState() => _AppDownState();
}

class _AppDownState extends State<AppDown> {
  AmizoneRepository _amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: CustomAppbar(
        "App Down",
        isBackEnabled: false,
        isCenter: true
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Icon(
              Icons.cloud_off,
              color: Colors.grey,
              size: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Server Down',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Expanded(child: Container()),
            RaisedButton(
              shape: StadiumBorder(),
              child: Text(
                'Retry'.toUpperCase(),
              ),
              onPressed: buttonPressed,
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  void buttonPressed() {
    _amizoneRepository.checkServerStatus().then((status) async {
      if (!status) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setBool("appDown", false);
        navKey.currentState
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    });
  }
}
