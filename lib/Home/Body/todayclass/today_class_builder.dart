import 'package:amihub/Database/database_helper.dart';
import 'package:amihub/Home/Body/todayclass/today_class_seamer.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TodayClassBuilder extends StatefulWidget {
  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  DateTime selectDate;

  @override
  void initState() {
    super.initState();
    selectDate = DateTime.now();
  }

  changeState(changedDate) {
    setState(() {
      selectDate = changedDate;
    });
  }

  Future<void> onRefresh() {
    setState(() {});
    return DatabaseHelper.db.deleteTodayClassesWithDate(
        "${selectDate.month}/${selectDate.day}/${selectDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Today's Classes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                  color: Colors.grey.shade700,
                  onPressed: (){
                    changeState(selectDate.subtract(Duration(days: 1)));
                  },
                ),
                FlatButton(
                  shape: StadiumBorder(),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 3, 5),
                        maxTime: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day).add(Duration(days: 10)), onConfirm: (date) {
                      setState(() {
                        selectDate = date;
                      });
                      changeState(selectDate);
                    }, currentTime: selectDate, locale: LocaleType.en);
                  },
                  child: Text(
                    '${DateFormat.yMMMMEEEEd("en_US").format(selectDate)}',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 20,
                  color: Colors.grey.shade700,
                  onPressed: (){
                    changeState(selectDate.add(Duration(days: 1)));
                  },
                ),
              ],
            ),
          ),
          buildFutureBuilder()
        ],
      ),
    );
  }

  FutureBuilder<List> buildFutureBuilder() {
    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchTodayClassWithDate(
          "${selectDate.month}/${selectDate.day}/${selectDate.year}",
          "${selectDate.month}/${selectDate.day}/${selectDate.year}"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return TodayClassShimmer();
          case ConnectionState.done:
            if (snapshot.hasError) return TodayClassError();
            // No Class check
            if (snapshot.data.elementAt(0)["title"] == "")
              return NoClassToday();
            return Container(
                child: TodayClassBuild(
              snapshot: snapshot,
            ));
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(''); // unreachable
      },
    );
  }
}

class TodayClassError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Today's Classes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Icon(
                      Icons.cloud_off,
                      color: Colors.white,
                      size: 108,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Could not fetch Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please Check Your internet and try again',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NoClassToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: width * 0.1,
          ),
          Container(
            child: Center(
              child: Icon(
                Icons.assignment_turned_in,
                color: Colors.white,
                size: 60,
              ),
            ),
            height: width * 0.3,
            width: width * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'All caught up!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Sit back,Relax! You have no classes today',
          ),
        ],
      ),
    );
  }
}

class TodayClassBuild extends StatelessWidget {
  final AsyncSnapshot<List<dynamic>> snapshot;

  TodayClassBuild({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: List.generate(snapshot.data.length, (int index) {
          return Column(
            children: <Widget>[
              ListTile(
                onTap: () {},
                title: Text(
                  snapshot.data[index]['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(snapshot.data[index]['courseCode']),
                leading: Container(
                  color: (snapshot.data[index]['color'] == "#f00")
                      ? Colors.red
                      : (snapshot.data[index]['color'] == "#4FCC4F")
                          ? Colors.green
                          : Colors.transparent,
                  width: 8,
                ),
                contentPadding: EdgeInsets.only(left: 0, right: 8),
              ),
              Divider(),
            ],
          );
        }),
      ),
    );
  }
}
