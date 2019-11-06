import 'dart:io';

import 'package:amihub/components/custom_alert_dialog.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final String imageLink;
  final String name;

  ProfileIcon({Key key, @required this.imageLink, @required this.name})
      : super(key: key);

  Future<void> _ackAlert(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        right: 4
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              imageLink,
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return Center(child: Icon(Icons.perm_identity,
                size: 30,));
              },
              fit: BoxFit.fitWidth,
              height: width * 0.25,
              width: width * 0.25,
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Logged in as..",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          IconButton(
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app),
            color: Colors.blueGrey,
            onPressed: () {
              _ackAlert(context);
            },
          )
        ],
      ),
    );
  }
}
