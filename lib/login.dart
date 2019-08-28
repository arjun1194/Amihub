import 'package:amihub/Components/textfield.dart';
import 'package:amihub/Login/login-inputs.dart';
import 'package:amihub/ViewModels/login_model.dart';
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
      Navigator.pushNamedAndRemoveUntil(
          context, '/captcha', (Route<dynamic> route) => false,
          arguments: loginModel);
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
      backgroundColor: Color(0xFFF7F7F9),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFf4f5f7),
              Color(0xFFf4f5f7).withOpacity(0.8)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Positioned(
            left: -width * 0.8,
            top: -width * 0.3,
            child: Container(
              width: height * 1.06,
              height: height * 1.06,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
          Positioned(
            top: height * 0.75,
            right: width * 0.2,
            child: MaterialButton(
              elevation: 8,
              highlightElevation: 10,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 30.0,
              ),
              color: Color(0xff3655B5),
              padding: EdgeInsets.all(24.0),
              onPressed: () {
                LoginModel loginModel = LoginModel(
                    usernameController.text, passwordController.text);
                login(loginModel);
              },
              splashColor: Colors.blueGrey.withOpacity(0.4),
              shape: CircleBorder(),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontFamily: "Playfair"),
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
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.4),
                  child: FlatButton(
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "Playfair"),
                    ),
                    splashColor: Colors.blueGrey[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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
