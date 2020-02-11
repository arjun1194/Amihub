import 'package:amihub/components/theme_changer.dart';
import 'package:amihub/routes/routes.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  //TODO: Remove this
  WidgetsFlutterBinding.ensureInitialized();
   Stetho.initialize();
  SystemChrome.setApplicationSwitcherDescription(
    ApplicationSwitcherDescription(
      label: "Amihub",
      primaryColor: 0xffffffff
    )
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool isDarkThemeEnabled;

  @override
  void initState() {
    super.initState();
    openSharedPref().then((value) {
      setState(() {});
    });
  }


  openSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDarkThemeEnabled = sharedPreferences.getBool('isDarkThemeEnabled');
    if (isDarkThemeEnabled == null) {
      isDarkThemeEnabled = false;
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
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      title: appTitle,
      routes: routes,
      theme: Provider.of<ThemeChanger>(context).getThemeData,
      darkTheme: darkTheme,
    );
  }
}
