import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:amihub/Theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ViewModels/login_model.dart';

class CaptchaPageNew extends StatefulWidget {
  @override
  _CaptchaPageNewState createState() => _CaptchaPageNewState();
}

class _CaptchaPageNewState extends State<CaptchaPageNew> {
  WebViewController _controller;

  bool isRendered = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _clearWebsite(
      WebViewController webViewController, BuildContext context) async {
    webViewController
        .evaluateJavascript(js_removeWebviewBackground)
        .then((value) {
      webViewController
          .evaluateJavascript(js_setWebviewBackgroundColor)
          .then((value) {
        webViewController.evaluateJavascript(js_setWebviewCenter);
      });
    });
  }

  _webView() {
    return WebView(
        initialUrl: "https://student.amizone.net",
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: [
          JavascriptChannel(
              name: "fuck",
              onMessageReceived: (message) {
                print("Again Fuck");
              })
        ].toSet(),
        onWebViewCreated: (webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (url) {
          setState(() {
            isRendered = true;
          });
          _clearWebsite(_controller, context);
        });
  }

  @override
  void initState() {
    super.initState();
  }

  getCaptchaResponse(
      WebViewController webViewController, BuildContext context) async {
    return webViewController.evaluateJavascript(js_getCaptchaResponse);
  }

  @override
  Widget build(BuildContext context) {
    final LoginModel args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
        body: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: _webView(),
        ),
        isRendered
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: RaisedButton(
                    child: Text("LOGIN"),
                    color: Colors.blueGrey[400],
                    splashColor: Colors.blueGrey[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    textColor: Colors.white,
                    highlightElevation: 5.0,
                    elevation: 7.0,
                    onPressed: () async {
                      String a = await getCaptchaResponse(_controller, context);
                      if (a.length > 10) {
                        print(a.substring(1, a.length - 1));
                        print('username = ${args.username}');
                        print('password = ${args.password}');
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Please slove the recaptcha"),
                        ));
                      }
                    },
                  ),
                ),
              )
            : Container()
      ],
    ));
  }
}
