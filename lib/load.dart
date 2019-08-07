import 'dart:convert';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/ViewModels/captcha_model.dart';
import 'package:amihub/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoadApi extends StatefulWidget {
  @override
  _LoadApiState createState() => _LoadApiState();
}

Future<String> isLoginSuccessful(username, password, gCaptcha, context) async {
  print("username $username password $password Captcha $gCaptcha");

  Response response;
  Dio dio = new Dio();
  String url = amihubUrl + "/login";
  response = await dio.get(url, queryParameters: {
    "username": username,
    "password": password,
    "captchaResponse": gCaptcha
  });
  print(response.data.toString());

  if (response.statusCode == 201) {
    print("Auth------------------>" + response.headers.value('Authorization'));
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home',
      (Route<dynamic> route) => false,
    );
  }
  if (response.statusCode == 401) {
    return "Either the username or password is incorrect!";
  }

  return response.data.toString();
}

class _LoadApiState extends State<LoadApi> {
  @override
  Widget build(BuildContext context) {
    final CaptchaModel args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<String>(
            future: isLoginSuccessful(
                args.username, args.password, args.captcha, context),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    'Awaiting result...',
                    style: headingStyle,
                  ));
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  return Center(
                      child: Text(
                    '${snapshot.data}',
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
}
