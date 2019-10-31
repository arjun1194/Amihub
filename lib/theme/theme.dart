//themedata : all the theme related information is in this file
import 'package:amihub/components/bottom_navigation_item.dart';
import 'package:flutter/material.dart';

//colors

const greenMain = Color(0xFF203782);
const fontMain = Color(0xFF0F100F);
const appBackground = Color(0xFFA3B9A6);
const whiteMain = Color(0xFFE0F3E8);
const greyMain = Color(0xFFA3B9A6);
const lightGreen = Color(0xFF203782);
const lighterGreen = Color(0xFFa1d1ba);

List<Color> lightColors = [
  Color(0xff19ddd3),
  Color(0xfffe914e),
  Color(0xfff72e50),
  Color(0xff6975d8)
];
List<Color> darkColors = [
  Color(0xff15c4f3),
  Color(0xffff5e50),
  Color(0xfffb3067),
  Color(0xff6c69d0)
];

List semesterList = [
'One',
'Two',
'Three',
'Four',
'Five',
'Six',
'Seven',
'Eight',
'Nine',
'Ten'
];

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: "GoogleSans",
  bottomSheetTheme: BottomSheetThemeData(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15))),
    elevation: 8,
  ),
  scaffoldBackgroundColor: Colors.black,
  backgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(),
);
var lightTheme = ThemeData(
    fontFamily: "GoogleSans",
    brightness: Brightness.light,
    bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        elevation: 8,
        backgroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    colorScheme: ColorScheme.light());

blackOrWhite(context) => Theme.of(context).brightness == Brightness.light
    ? Colors.white
    : Colors.black;
const appTitle = 'Amihub';
const appIcon = 'assets/logo.png';



//api end point
var amihubUrl = 'http://api.avirias.me:8080';

String facultyImage(String code) =>
    "https://amizone.net/AdminAmizone/images/StaffImages/${code}_p.png";

//Webview url
var webViewUrl = 'https://student.amizone.net';

//javascript-code
var js_removeWebviewBackground =
    "var el11 = document.getElementsByClassName('wrap-login100')[0];el11.classList.remove('wrap-login100');var el12 = document.getElementsByClassName('container-login100')[0];el12.classList.remove('container-login100');var el1 = document.getElementsByClassName('logo-section')[0];el1.parentNode.removeChild(el1);var el2 = document.getElementsByClassName('login100-form-title')[0];el2.parentNode.removeChild(el2);var el3 = document.getElementsByClassName('wrap-input100 validate-input')[0];el3.parentNode.removeChild(el3);var el4 = document.getElementsByClassName('wrap-input100 validate-input')[0];el4.parentNode.removeChild(el4);var el5 = document.getElementsByClassName('container-login100-form-btn')[0];el5.parentNode.removeChild(el5);var el6 = document.getElementsByClassName('text-center p-t-12 fg-password')[0];el6.parentNode.removeChild(el6);var el8 = document.getElementsByClassName('widget-box forgot-box login100-form')[0];el8.parentNode.removeChild(el8);var el9 = document.getElementsByClassName('login100-pic')[0];el9.parentNode.removeChild(el9);";
var js_setWebviewBackgroundColor =
    "document.getElementsByTagName('body')[0].style.backgroundColor = '#fafafa';";
var js_setWebviewCenter =
    "document.getElementById('login-box').style='position:absolute !important;top:150px !important;left:25% !important;width:60% !important; '";
var js_getCaptchaResponse =
    "document.getElementById('g-recaptcha-response').value;";

List<BottomNavigationBarItem> list = [
  BottomNavItem(
          "Home",
          Icon(
            Icons.home,
          ),
          greenMain,
          "Home")
      .bottomNavItem,
  BottomNavItem(
          "Academics",
          Icon(
            Icons.school,
          ),
          greenMain,
          "Home")
      .bottomNavItem,
  BottomNavItem(
          "Chat",
          Icon(
            Icons.question_answer,
          ),
          greenMain,
          "Home")
      .bottomNavItem,
  BottomNavItem(
          "Profile",
          Icon(
            Icons.person,
          ),
          greenMain,
          "Home")
      .bottomNavItem,
];
