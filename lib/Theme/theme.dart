//themedata : all the theme related information is in this file
import 'package:amihub/Components/bottom_navigation_item.dart';
import 'package:flutter/material.dart';

//colors

const greenMain = Color(0xFF203782);
const fontMain = Color(0xFF0F100F);
const appBackground = Color(0xFFA3B9A6);
const whiteMain = Color(0xFFE0F3E8);
const greyMain = Color(0xFFA3B9A6);
const lightGreen = Color(0xFF203782);
const lighterGreen = Color(0xFFa1d1ba);


const lightOrange = Color(0xffFF8F53);
const darkOrange = Color(0xffFE614E);
const lightRed = Color(0xffF72F54);
const darkRed = Color(0xffFD2E6A);
const lightPurple = Color(0xff6974DD);
const darkPurple = Color(0xff6B69C9);
const lightBlue = Color(0xff12CCD9);
const darkBlue = Color(0xff0FC5F3);
const lightIndigo = Color(0xff3660FA);
const darkIndigo = Color(0xff5759F9);
//const texts
const appTitle = 'Amihub';

//font-family
const fontSplashScreen = 'Roboto';

//text styles
const headingStyle =
    TextStyle(fontSize: 40, fontFamily: 'Raleway', fontWeight: FontWeight.bold);
const buttonTextStyle = TextStyle(color: Colors.white, fontFamily: 'Raleway');

//api end point
var amihubUrl = 'http://api.avirias.me:8080';

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
