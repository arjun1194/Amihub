import "dart:math";

import 'package:flutter/material.dart';

var list = [
  Colors.red,
  Colors.green,
  Colors.pink,
  Colors.blue,
  Colors.orange,
  Colors.teal,
  Colors.grey,
  Colors.lime
];


Color createRandomColor(){
  final _random = new Random();
  Color element = list[_random.nextInt(list.length)];
  return element;
}
// generates a new Random color from the list
