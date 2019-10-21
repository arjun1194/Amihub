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
    final LoginModel args = ModalRoute
        .of(context)
        .settings
        .arguments;

    return FutureBuilder<Response>(
      future: _amizoneRepository.login(args.username, args.password),
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(body: Center(
                child: Center(child: CircularProgressIndicator())));
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: greenMain, title: Text("Login Failed"),),
                body: Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/authentication.png'),
                    ), Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text('Aw snap! we hit a roadblock',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),),
                    ), Text("Some error has occured")]),
              );
            }
            if (snapshot.data.statusCode == 401) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: greenMain, title: Text("Login Failed"),),
                body: Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/authentication.png'),
                    ), Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text('Aw snap! we hit a roadblock',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),),
                    ), Text(snapshot.data.body.toString())]),
              );
            }
            else
              SharedPreferences.getInstance().then((sharedPreferences) {
                sharedPreferences.setString(
                    "Authorization", snapshot.data.headers['authorization'])
                    .then((saved) {
                      Future.delayed(Duration(seconds: 2));
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (Route<dynamic> route) => false);
                });
              });

            return Scaffold(
              body: Column(mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/authentication.png'),
                    ), Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text('Welcome to $appTitle',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),),
                    ), Text("Logging you in to your profile")]),
            );
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _amizoneRepository = AmizoneRepository();
  }


}
