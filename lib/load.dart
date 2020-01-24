import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:amihub/viewModels/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadApi extends StatefulWidget {
  @override
  _LoadApiState createState() => _LoadApiState();
}

class _LoadApiState extends State<LoadApi> {
  AmizoneRepository _amizoneRepository;

  @override
  Widget build(BuildContext context) {
    final LoginModel args = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<Response>(
      future: _amizoneRepository.login(args.username, args.password),
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(body: Loader());
          case ConnectionState.done:
            if (snapshot.data == null || snapshot.data.statusCode >= 500) {
              return ServerUnreachable();
            }
            if (snapshot.hasError) {
              return errorPage(snapshot.error);
            }
            if (snapshot.data.statusCode == 401) {
              return usernameOrPasswordIncorrect(snapshot);
            } else
              SharedPreferences.getInstance().then((sharedPreferences) {
                sharedPreferences.setBool("appDown", false);
                sharedPreferences.setString(
                    "Authorization", snapshot.data.headers['authorization']).then((saved) {
                  Future.delayed(Duration(seconds: 3));
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (Route<dynamic> route) => false);
                });
              });
            return successLogin();
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }

  Scaffold errorPage(Object error) {
    return Scaffold(
        appBar: CustomAppbar(
          "Login Failed",
        ),
        body: ErrorPage(error));
  }

  Scaffold usernameOrPasswordIncorrect(AsyncSnapshot<Response> snapshot) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenMain,
        title: Text("Login Failed"),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: Image.asset('assets/authentication.png')),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(bottom: 180),
          child: Column(
            children: <Widget>[
              Text(
                'Aw snap! we hit a roadblock',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                snapshot.data.body.toString().toLowerCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Scaffold successLogin() {
    return Scaffold(
      appBar: CustomAppbar(
        'Logging in..',
        isBackEnabled: false,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to $appTitle',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Logging you in to your profile",
                style: TextStyle(fontSize: 16),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Loader(),
              )
            ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _amizoneRepository = AmizoneRepository();
  }
}

class ServerUnreachable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: width * 0.7),
                ),
                Text(
                  ':(',
                  style: TextStyle(fontSize: 50),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Can't connect to our server",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Please try again",
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: OutlineButton(
                    child: Text('go back'.toUpperCase()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: StadiumBorder(),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
