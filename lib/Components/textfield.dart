import 'package:flutter/material.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController textEditingController;

  MyTextField(
      {Key key, this.hintText, this.keyboardType, this.obscureText, this.textEditingController})
      : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
      child: TextField(
        keyboardType: widget.keyboardType,
        autofocus: false,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(borderSide: BorderSide(color: greyMain)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: lightGreen))),
        controller:widget.textEditingController ,
      ),
    );
  }
}

//this.hintText,this.keyboardType,this.obscureText
