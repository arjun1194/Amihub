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
    super.initState();
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
      Future.delayed(Duration.zero, () {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        flutterWebViewPlugin.launch(
          webViewUrl,
          hidden: false,
          rect: Rect.fromLTWH(width/2 - 120, width*0.5, 240, 100)
        );
      });
    }
  }

  @override
  void dispose() {
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
    super.dispose();

  }

  getCaptchaResponse(String username, String password) async {
    await flutterWebViewPlugin
        .evalJavascript(js_getCaptchaResponse)
        .then((String value) {
      if (value.length > 0) {
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.dispose();
        return value.substring(1, value.length - 1);
      } else {
        return null;
      }
    });
  }

  nextPage(username, password) {
    getCaptchaResponse(username, password).then((String value) {
      CaptchaModel captchaModel = CaptchaModel(username, password, value);
      Navigator.pushNamedAndRemoveUntil(
          context, '/load', (Route<dynamic> route) => false,
          arguments: captchaModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final LoginModel args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(),
        child: RaisedButton(
          child: Text("LOGIN"),
          color: Colors.blueGrey[400],
          splashColor: Colors.blueGrey[200],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)),
          textColor: Colors.white,
          highlightElevation: 5.0,
          elevation: 7.0,
          onPressed: () {},
        ),
      ),
    );
  }
}
