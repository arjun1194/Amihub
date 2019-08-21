import 'dart:async';

import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ViewModels/captcha_model.dart';
import 'ViewModels/login_model.dart';

//TODO: initialize this as sson as JWT isnt found so that webpage loading is faster, also Make a Internet connection not availabe detector
class CaptchaPageNew extends StatefulWidget {
  @override
  _CaptchaPageNewState createState() => _CaptchaPageNewState();
}

class _CaptchaPageNewState extends State<CaptchaPageNew> {
  WebViewController _controller;

  bool isRendered = false;
  var _stackIndex;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _clearWebsite(
      WebViewController webViewController, BuildContext context) async {
    webViewController
        .evaluateJavascript(js_removeWebviewBackground)
        .then((value) {
      webViewController.evaluateJavascript(js_setWebviewCenter);
    });
  }

  _webView() {
    return WebView(
        initialUrl: "https://student.amizone.net",
        debuggingEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (url) {
          _clearWebsite(_controller, context);
          setState(() {
            isRendered = true;
          });
          Timer(Duration(milliseconds: 100), () {
            setState(() {
              _stackIndex = 0;
            });
          });
        });
  }

  @override
  void initState() {
    super.initState();
    _stackIndex = 1;
  }

  getCaptchaResponse(
      WebViewController webViewController, BuildContext context) async {
    return webViewController.evaluateJavascript(js_getCaptchaResponse);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var statusBarHeight = MediaQuery.of(context).padding.top;
    final LoginModel args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: _stackIndex,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: _webView(),
                  ),
                ),
                isRendered
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: width * 0.15),
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
                              String a = await getCaptchaResponse(
                                  _controller, context);
                              if (a.length > 10) {
                                String captcha = a.substring(1, a.length - 1);
                                CaptchaModel captchaModel = CaptchaModel(
                                    args.username, args.password, captcha);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/load', (Route<dynamic> route) => false,
                                    arguments: captchaModel);
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Please slove the recaptcha"),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(milliseconds: 1500),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 5,
                                  backgroundColor: Color(0xff1F1B24),
                                ));
                              }
                            },
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Center(child: CircularProgressIndicator())
          ],
        ));
  }
}
