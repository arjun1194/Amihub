import 'dart:io';

import 'package:amihub/components/page_heading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkEnabled = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeader('Settings'),
          ListTile(
            leading: Icon(Icons.brightness_4),
            title: Text('Dark mode'),
            subtitle: isDarkEnabled
                ? Text('Disable dark mode')
                : Text('Enable dark mode'),
            trailing: Platform.isIOS
                ? CupertinoSwitch(
                    value: isDarkEnabled,
                    onChanged: (value) {
                      if (value) {}
                    },
                  )
                : Switch(
                    value: isDarkEnabled,
                    onChanged: (value) {},
                  ),
          )
        ],
      ),
    );
  }
}
