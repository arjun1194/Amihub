import 'package:amihub/components/theme_changer.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/routes.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isDarkThemeEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    openSharedPref().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  openSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDarkThemeEnabled = sharedPreferences.getBool('isDarkThemeEnabled');
    if (isDarkThemeEnabled == null) {
      isDarkThemeEnabled = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
//      if (Theme.of(context).brightness == Brightness.light)
//        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//            systemNavigationBarIconBrightness: Brightness.dark,
//            systemNavigationBarColor: Colors.white));
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user quit our app temporally
    } else if (state == AppLifecycleState.suspending) {
      // app suspended
    }
  }

  @override
  Widget build(BuildContext context) {
    return isDarkThemeEnabled == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ChangeNotifierProvider<ThemeChanger>(
            builder: (context) =>
                ThemeChanger(isDarkThemeEnabled ? darkTheme : lightTheme),
            child: MaterialAppWithTheme());
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application 1',
      routes: routes,
      theme: Provider.of<ThemeChanger>(context).getThemeData,
      darkTheme: darkTheme,
    );
  }
}
