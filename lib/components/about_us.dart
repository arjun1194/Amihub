import 'package:amihub/components/custom_appbar.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUS extends StatefulWidget {
  @override
  _AboutUSState createState() => _AboutUSState();
}

class _AboutUSState extends State<AboutUS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar('About Us'),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            PageHeader('Team'),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                avatar("Avinash Kumar"),
                avatar("Arjun Bhardwaj")
              ],
            ),
            SizedBox(height: 15),
            PageHeader('Our Aim'),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color:
                    isLight(context) ? Colors.grey.shade100 : Color(0xff121212),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    aboutUs,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                  ),
                ),
              ),
            ),
            PageHeader('Our Socials'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                githubButton("@avirias", "https://github.com/avirias"),
                githubButton("@arjun1194", "https://github.com/arjun1194")
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  RaisedButton githubButton(String username, String link) {
    return RaisedButton(
      highlightElevation: 2,
      focusElevation: 2,
      hoverElevation: 2,
      onPressed: () {
        launchUrl(link);
      },
      shape: StadiumBorder(),
      color: isLight(context) ? Colors.grey.shade100 : Color(0xff121212),
      elevation: 0,
      child: Row(
        children: <Widget>[
          Image.network('https://img.icons8.com/windows/32/000000/github.png'),
          Text(username),
        ],
      ),
    );
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Container avatar(String name) {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Container(
                child: CircleAvatar(
                  backgroundColor: isLight(context) ? Colors.blue : Color(0xff121229),
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 65),
              child: Container(
                width: 110,
                padding: EdgeInsets.all(7),
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: isLight(context)
                      ? Colors.grey.shade100
                      : Color(0xff121212),
                ),
                child: Center(child: Text(name)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
