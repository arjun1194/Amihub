import 'package:flutter/foundation.dart';

class BackdropSelected with ChangeNotifier{
  int _selected ;

  BackdropSelected({int selected}) {
    this._selected = selected;
  }

  int get selected => _selected??0;
  set selected(int selected) {
    _selected = selected;
    notifyListeners();
  }
}