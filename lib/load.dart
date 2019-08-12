import 'dart:convert';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/ViewModels/captcha_model.dart';
import 'package:amihub/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadApi extends StatefulWidget {
  @override
  _LoadApiState createState() => _LoadApiState();
}

class _LoadApiState extends State<LoadApi> {


  @override
  Widget build(BuildContext context) {
    final CaptchaModel args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<Response>(
            future: loginWithUsername(args.username, args.password, args.captcha),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  SharedPreferences.getInstance().then((sharedPreferences){
                      sharedPreferences.setString("Authorization", snapshot.data.headers['authorization']).then((saved){
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                      });
                  });
                  return Center(
                      child: Text(
                    '',
                    style: headingStyle,
                  ));
                case ConnectionState.none:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.active:
                  // TODO: Handle this case.
                  break;
              }
              return Text("End"); // unreachable
            },
          )
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(LoadApi oldWidget) {
    print("somthing changed!!!!!!!!!!!!!!!");
  }

  Future<Response> loginWithUsername(
      String username, String password, String gcaptcha) async{
    Client client = Client();
    String url = amihubUrl +
        "/login?username=$username&password=$password&captchaResponse=$gcaptcha";
     Response resp =  await client.get(url);
    if (resp.statusCode == 201) {
        return resp;
    }
  }
}
