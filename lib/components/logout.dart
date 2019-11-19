import 'dart:io';

import 'package:amihub/components/custom_alert_dialog.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> logoutDialog(BuildContext context) {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  var dialog = PlatformAlertDialog(
    title: Text(
      'Log out',
      style: TextStyle(
        color: isLight(context) ? Colors.blueGrey.shade700 : Colors.white,
      ),
    ),
    content:  const Text('Really wanna go? '),
    actions: Platform.isIOS ? <Widget>[
      CupertinoDialogAction(
        child: Text(
          "Cancel",
          style: TextStyle(
            color: isLight(context) ? Colors.blueGrey.shade800 : Colors.white,
          ),
        ),
        onPressed: (){
          Navigator.pop(context);
        },
        isDefaultAction: true,
      ),
      CupertinoDialogAction(
        child: Text(
          'Logout',
          style: TextStyle(
            color: isLight(context) ? Colors.blueGrey.shade800 : Colors.white,
          ),
        ),
        onPressed: () {
          amizoneRepository.logout(context);
        },
        isDefaultAction: false,
        isDestructiveAction: true,
      )
    ]: [
      FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          "Cancel",
          style: TextStyle(
            color: isLight(context) ? Colors.blueGrey.shade800 : Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          'Logout',
          style: TextStyle(
            color: isLight(context) ? Colors.blueGrey.shade800 : Colors.white,
          ),
        ),
        onPressed: () {
          amizoneRepository.logout(context);
        },
      ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 8,
  );

  return Platform.isIOS?
  showCupertinoDialog(
      context: context,
      builder: (BuildContext context){
        return dialog;
      }
  )
      :showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );

}