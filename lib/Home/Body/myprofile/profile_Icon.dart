import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  String imageLink;
  String name;

  ProfileIcon({Key key, @required this.imageLink,@required this.name}) : super(key: key);

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,),),
          content: const Text('Really wanna leave, Not yet Motherfucker!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Go back',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    print(imageLink);
    return ListTile(
              leading: Container(width: 54.0, height: 54.0, decoration: new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new NetworkImage(imageLink.toString())))),
              title: Text("Logged in as"),
              subtitle: Text(name,style: TextStyle(fontSize: 20),),
              trailing:IconButton(icon:Icon(Icons.exit_to_app),onPressed: (){_ackAlert(context);},));
  }
}