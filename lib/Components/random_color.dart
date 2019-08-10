import "dart:math";
import 'package:flutter/material.dart';

import 'package:amihub/Theme/theme.dart';

var list = [cardColor1,cardColor2,cardColor3,cardColor4,cardColor5,cardColor6];


Color createRandomColor(){
  final _random = new Random();
  Color element = list[_random.nextInt(list.length)];
  return element;
}
// generates a new Random color from the list
