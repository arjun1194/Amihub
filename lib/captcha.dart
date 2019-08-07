import 'dart:async';
import 'package:amihub/Login/login-button.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/Components/appbar.dart';
import 'package:amihub/ViewModels/login_model.dart';
import 'package:amihub/load.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'ViewModels/captcha_model.dart';

class CaptchaPage extends StatefulWidget {
  @override
  _CaptchaPageState createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> {

  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  bool _checkConfiguration() => true;


  @override
  void initState() {
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          flutterWebViewPlugin.evalJavascript(js_removeWebviewBackground);
          flutterWebViewPlugin.evalJavascript(js_setWebviewBackgroundColor);
          flutterWebViewPlugin.evalJavascript(js_setWebviewCenter);
        });
      }
    });
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero,() {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        flutterWebViewPlugin.launch(
          webviewUrl,
          hidden: false,
          rect: new Rect.fromLTWH(0, appbarHeight + 32, width, height * 0.7),
        );
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
  }

   getCaptchaResponse(String username, String password) async {
    await flutterWebViewPlugin.evalJavascript(js_getCaptchaResponse).then((String value) {
      if (value.length > 0)
      {
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.dispose();
        return value.substring(1, value.length - 1);
      }else{
        return null;
      }
    });
  }

  nextPage(username,password){
    getCaptchaResponse(username, password).then((String value){

      CaptchaModel captchaModel = CaptchaModel(username,password,value);
      Navigator.pushNamedAndRemoveUntil(context,'/load',(Route<dynamic> route) => false,arguments: captchaModel);
    });
  }

  @override
  Widget build(BuildContext context) {

    final LoginModel args = ModalRoute.of(context).settings.arguments;


    return Scaffold(
        appBar: myAppbar,
        body: Center(
            child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Next"),
                    onPressed: () {nextPage(args.username, args.password);},
                    color: lightGreen,
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
