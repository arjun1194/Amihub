import 'package:amihub/components/textfield.dart';
import 'package:amihub/login/login-inputs.dart';
import 'package:amihub/theme/theme.dart';
import 'package:amihub/viewModels/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginInputs inputs;
  MyTextField username;
  MyTextField password;
  TextEditingController usernameController;
  TextEditingController passwordController;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    //
    inputs = LoginInputs();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    username = MyTextField(
      hintText: "Username",
      obscureText: false,
      keyboardType: TextInputType.number,
      textEditingController: usernameController,
    );
    password = MyTextField(
      hintText: "Password",
      obscureText: true,
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
    );
  }

  void login(LoginModel loginModel) {
    if (username != null && password != null) {
      Navigator.pushNamed(context, '/load', arguments: loginModel);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please Enter Username and Password"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  void forgotPassword() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/Forgot', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
//      backgroundColor: Theme.of(context).brightness == Brightness.light
//          ? Color(0xFFF7F7F9)
//          : Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.light
                        ? [
                            Color(0xFFf4f5f7),
                            Color(0xFFf4f5f7).withOpacity(0.8)
                          ]
                        : [Colors.grey, Colors.grey.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Positioned(
            left: -width * 0.8,
            top: -width * 0.3,
            child: Container(
              width: height * 1.06,
              height: height * 1.06,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.grey.shade900),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AnimatedPadding(
              padding: EdgeInsets.only(
                  right: width * 0.2,
                  // Checks if keyboard is open or not
                  bottom: MediaQuery.of(context).viewInsets.bottom != 0
                      ? 20
                      : height * 0.25),
              duration: Duration(microseconds: 200),
              curve: ElasticInOutCurve(),
              child: MaterialButton(
                elevation: 8,
                highlightElevation: 10,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30.0,
                ),
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xff3655B5)
                    : Color(0xff364042),
                padding: EdgeInsets.all(24.0),
                onPressed: () {
                  if (usernameController.text.length == 0 ||
                      passwordController.text.length == 0) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Please enter username and passsword'),
                    ));
                  } else if (!RegExp(r'[0-9]')
                      .hasMatch(usernameController.text)) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Username can't be alphabet"),
                    ));
                  } else {
                    LoginModel loginModel = LoginModel(
                        usernameController.text, passwordController.text);
                    login(loginModel);
                  }
                },
                splashColor: Colors.blueGrey.withOpacity(0.4),
                shape: CircleBorder(),
              ),
            ),
          ),
          Positioned(
            top: width * 0.25,
            left: width * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Log In",
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontFamily: "Playfair",
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: width * 0.7,
                  child: MyTextField(
                    hintText: "Username",
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    textEditingController: usernameController,
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                SizedBox(
                  width: width * 0.7,
                  child: MyTextField(
                    hintText: "Password",
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textEditingController: passwordController,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.4),
                  child: OutlineButton(
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: 14.5,
                      ),
                    ),
                    shape: StadiumBorder(),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
