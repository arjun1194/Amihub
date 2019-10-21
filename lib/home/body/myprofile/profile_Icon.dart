import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final String imageLink;
  final String name;

  ProfileIcon({Key key, @required this.imageLink, @required this.name})
      : super(key: key);

  Future<void> _ackAlert(BuildContext context) {
    AmizoneRepository amizoneRepository = AmizoneRepository();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            'Log out',
            style: TextStyle(
              color: Colors.blueGrey.shade700,
            ),
          ),
          content: const Text('Really wanna go? '),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blueGrey.shade800),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.blueGrey.shade800,
                ),
              ),
              onPressed: () {
                amizoneRepository.logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Image.network(
              imageLink,
              loadingBuilder: (BuildContext context,
                  Widget child,
                  ImageChunkEvent loadingProgress,) {
                if (loadingProgress == null)
                  return child;
                return Center(
                  child: Icon(Icons.perm_identity)
                );
              },
              fit: BoxFit.fitWidth,
              height: 90,
              width: 90,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Logged in as..",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              )
            ],
          ),
          IconButton(
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app),
            color: Colors.blueGrey.shade700,
            onPressed: () {
              _ackAlert(context);
            },
          )
        ],
      ),
    );
  }
}
