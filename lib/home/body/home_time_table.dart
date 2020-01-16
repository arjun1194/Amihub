import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/components/under_development.dart';
import 'package:amihub/models/timetable.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeTimeTable extends StatelessWidget {
  final AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isLight(context) ? Colors.white : Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          PageHeader('Time Table'),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: FutureBuilder(
              future: amizoneRepository.networkCallTimeTable(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TimeTable>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return Loader();
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    return (snapshot.hasError || snapshot.data == null)
                        ? ErrorPage()
                        : TimeTableBuild(timetables: snapshot.data);
                }
                return Text('end');
              },
            ),
          )
        ],
      ),
    );
  }
}

class TimeTableBuild extends StatelessWidget{

  final List<TimeTable> timetables;

  TimeTableBuild({this.timetables});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopment();
  }


}
