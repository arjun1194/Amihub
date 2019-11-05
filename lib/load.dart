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
            if (snapshot.hasError) {
              return errorPage();
            }
            if (snapshot.data.statusCode == 401) {
              return usernameOrPasswordIncorrect(snapshot);
            } else
              SharedPreferences.getInstance().then((sharedPreferences) {
                sharedPreferences
                    .setString(
                        "Authorization", snapshot.data.headers['authorization'])
                    .then((saved) {
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

  Scaffold errorPage() {
    return Scaffold(
        appBar: CustomAppbar(
          "Login Failed",
        ),
        body: ErrorPage());
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
          padding: const EdgeInsets.only(bottom: 200),
          child: Column(
            children: <Widget>[
              Text(
                'Aw snap! we hit a roadblock',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                snapshot.data.body.toString(),
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
