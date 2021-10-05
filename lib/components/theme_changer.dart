import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier{
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  ThemeData get getThemeData => _themeData;

  setThemeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }


}