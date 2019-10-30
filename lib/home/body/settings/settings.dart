import 'dart:io';

import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/theme_changer.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    bool isDarkModeSupported =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool isDarkThemeEnabled = Theme.of(context).brightness == Brightness.dark;
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
            subtitle: isDarkModeSupported
                ? Text('Dark theme enabled by OS')
                : isDarkThemeEnabled
                    ? Text('Disable dark mode')
                    : Text('Enable dark mode'),
            trailing: Platform.isIOS
                ? CupertinoSwitch(
                    value: isDarkThemeEnabled,
                    onChanged: !isDarkModeSupported
                        ? (value) {
                            if (value)
                              themeChanger.setThemeData(darkTheme);
                            else
                              themeChanger.setThemeData(lightTheme);

                          }
                        : null,
                  )
                : Switch(
                    value: isDarkThemeEnabled,
                    onChanged: !isDarkModeSupported
                        ? (value) async {
                            if (value)
                              themeChanger.setThemeData(darkTheme);
                            else
                              themeChanger.setThemeData(lightTheme);

                            SharedPreferences sp = await SharedPreferences.getInstance();
                            sp.setBool('isDarkThemeEnabled', value);
                          }
                        : null,
                  ),
          )
        ],
      ),
    );
  }
}
