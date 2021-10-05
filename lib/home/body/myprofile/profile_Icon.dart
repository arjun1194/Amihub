
import 'package:amihub/components/logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final String imageLink;
  final String name;

  ProfileIcon({Key key, @required this.imageLink, @required this.name})
      : super(key: key);



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
              logoutDialog(context);
            },
          )
        ],
      ),
    );
  }
}
