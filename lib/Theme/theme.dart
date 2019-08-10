//themedata : all the theme related information is in this file
import 'package:flutter/material.dart';

//colors

const greenMain = Color(0xFF203782);
const fontMain = Color(0xFF0F100F);
const appBackground = Color(0xFFA3B9A6);
const whiteMain = Color(0xFFE0F3E8);
const greyMain = Color(0xFFA3B9A6);
const lightGreen = Color(0xFF203782);
const lighterGreen = Color(0xFFa1d1ba);



const cardColor1= Color(0xFFC2BBD8);
const cardColor2 = Color(0xFF93B198);
const cardColor3 = Color(0xFFB1AE8F);
const cardColor4 = Color(0xFFB19A9A);
const cardColor5 = Color(0xFF8391B1);
const cardColor6 = Color(0xFF83B1A4);


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
    "document.getElementById('login-box').style='position:absolute !important;top:300px !important;left:25% !important;width:200px !important; '";
var js_getCaptchaResponse =
    "document.getElementById('g-recaptcha-response').value;";
