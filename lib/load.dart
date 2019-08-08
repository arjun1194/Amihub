import 'dart:convert';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/ViewModels/captcha_model.dart';
import 'package:amihub/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoadApi extends StatefulWidget {
  @override
  _LoadApiState createState() => _LoadApiState();
}



class _LoadApiState extends State<LoadApi> {

  isLoginSuccessful(String username,String password,String gcaptcha,BuildContext context){
    loginWithUsername(username, password, gcaptcha).then((Response resp){
        if(resp.statusCode==201){
          //login was successful so get JWT as a response body and use it to fetch other API's
          //save the JWT in sharedPreferences
          //Navigator.pushNamedRemoveUntil(/home);
        }
    });
  }



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

  Future<Response> loginWithUsername(String username,String password,String gcaptcha) {
    Client client = Client();
    String url = amihubUrl+"/login?username=$username&password=$password&captchaResponse=$gcaptcha";
    return client.get(url);

  }


}
