import 'package:flutter/material.dart';
import 'package:amihub/Theme/theme.dart';


class MyTextField extends StatelessWidget {
  MyTextField(this.hintText,this.keyboardType,this.obscureText);
  final hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController textEditingController = TextEditingController();

  String getText(){
    return textEditingController.text;

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: TextField(
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: greyMain)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: lightGreen))),
        controller: textEditingController,
      ),
    );
  }


}
