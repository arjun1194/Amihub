import 'package:amihub/Components/today_class_card.dart';
import 'package:amihub/Components/today_class_seamer.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:flutter/material.dart';

class TodayClassBuilder extends StatefulWidget {
  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchTodayClass(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return TodayClassSeamer();
          case ConnectionState.done:
            return (snapshot.hasError || snapshot.data == null) ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Some error has occured Please try again later!"),
                RaisedButton(child: Text("Retry"), onPressed: () {
                  setState(() {});
                },)
              ],
            ) : Container(child: Row(
              children: List.generate(snapshot.data.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TestWidget(
                      snapshot.data[index]['title'],
                      snapshot.data[index]['facultyName'].toString().substring(
                          0, snapshot.data[index]['facultyName']
                          .toString()
                          .indexOf('[')),
                      snapshot.data[index]['attendanceColor'],
                      snapshot.data[index]['roomNo'],
                      snapshot.data[index]['courseCode'],
                      snapshot.data[index]['start'],
                      snapshot.data[index]['end'],
                      lightColors[0],
                      darkColors[1]),
                );
              }),
            ),);
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }
}
