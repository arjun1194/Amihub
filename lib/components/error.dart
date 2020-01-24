import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final Object error;

  ErrorPage(this.error);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  int count;

  @override
  void initState() {
    super.initState();
    count = 0;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print(widget.error);
    return Container(
      color: blackOrWhite(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                print(count);
                setState(() {
                  count++;
                });
              },
              child: Image.asset('assets/error.png',
                  height: width * 0.5, width: width * 0.5),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Oopsie !',
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Something doesn't seem Kosher \nabout these pigs",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 40,
            ),
            count >= 20 && count <=25
                ? Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      widget.error.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
