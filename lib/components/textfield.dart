import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Function(String) onSubmit;

  MyTextField(
      {Key key,
      this.hintText,
      this.keyboardType,
      this.obscureText,
      this.textEditingController,
      this.onSubmit})
      : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool passwordVisible;


  @override
  void initState() {
    super.initState();
    passwordVisible = widget.obscureText ? true : false;
    // to unhide the status bar
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // to hide the status bar
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardAppearance: Theme.of(context).brightness,
      keyboardType: widget.keyboardType,
      autofocus: false,
      obscureText: passwordVisible,
      maxLines: 1,
      cursorColor: Colors.blueGrey.shade800,
      decoration: InputDecoration(
          fillColor: isLight(context)
              ? Colors.white
              : Colors.grey.shade900,
          filled: true,
          focusColor: Color(0xff656C8C),
          labelText: widget.hintText,
          labelStyle: TextStyle(
            color: isLight(context)
                ? Colors.blueGrey.shade800
                : Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isLight(context)
                      ? Color(0xff656C8C)
                      : Colors.grey),
              borderRadius: BorderRadius.circular(30)),
          contentPadding:
              EdgeInsets.only(left: 22, top: 18, bottom: 18, right: 22),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blueGrey)),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  child: passwordVisible
                      ? Icon(
                          Icons.remove_red_eye,
                          color:
                              isLight(context)
                                  ? Color(0xff3A4577)
                                  : Colors.grey.shade700,
                        )
                      : Icon(Icons.visibility_off,
                          color:
                              isLight(context)
                                  ? Color(0xff3A4577)
                                  : Colors.grey.shade700))
              : null),
      controller: widget.textEditingController,
      onSubmitted: widget.onSubmit,
    );
  }
}
