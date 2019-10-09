import 'package:amihub/Database/database_helper.dart';
import 'package:amihub/Home/Body/todayclass/today_class_seamer.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
      onRefresh: onRefresh, child: FutureBuilder<List<dynamic>>(
      future:
      amizoneRepository.fetchTodayClassWithDate("${selectDate.month}/${selectDate.day}/${selectDate.year}","${selectDate.month}/${selectDate.day}/${selectDate.year}"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return TodayClassSeamer();
          case ConnectionState.done:
            if (snapshot.hasError) return TodayClassError();
            if (snapshot.data.elementAt(0) == "No Class") return NoClassToday(
              onChange: changeState, selectDate: selectDate,);
            return Container(child: TodayClassBuild(snapshot: snapshot,
              onChange: changeState,
              selectDate: selectDate,));
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(''); // unreachable
      },
    ),);
  }
}

class TodayClassError extends StatefulWidget {
  @override
  _TodayClassErrorState createState() => _TodayClassErrorState();
}

class _TodayClassErrorState extends State<TodayClassError> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Today's Classes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                      Icons.cloud_off, color: Colors.white, size: 108,),
                    decoration: BoxDecoration(color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(999)),),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Could not fetch Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please Check Your internet and try again',),
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

class NoClassToday extends StatefulWidget {
  final Function(DateTime) onChange;
  DateTime selectDate;


  NoClassToday({Key key, @required this.onChange, @required this.selectDate});

  @override
  _NoClassTodayState createState() => _NoClassTodayState();
}

class _NoClassTodayState extends State<NoClassToday> {

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Today's Classes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Pick Date", style: TextStyle(fontSize: 18),),
            FlatButton(onPressed: () {
              DatePicker.showDatePicker(context, showTitleActions: true,
                  minTime: DateTime(2018, 3, 5),
                  maxTime: DateTime(DateTime
                      .now()
                      .year,
                      DateTime
                          .now()
                          .month,
                      DateTime
                          .now()
                          .day),
                  onConfirm: (date) {
                    setState(() {
                      widget.selectDate = date;
                    });
                    widget.onChange(widget.selectDate);
                  },
                  currentTime: widget.selectDate,
                  locale: LocaleType.en);
            },
              child: Text(
                '${widget.selectDate.day}/${widget.selectDate.month}/${widget
                    .selectDate.year}',
                style: TextStyle(color: Colors.blue),),),
          ],),
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
                      Icons.assignment_turned_in, color: Colors.white,
                      size: 108,),
                    decoration: BoxDecoration(color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(999)),),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('All caught up!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Sit back,Relax! You have no classes today',),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class TodayClassBuild extends StatefulWidget {

  final AsyncSnapshot<List<dynamic>> snapshot;
  final Function(DateTime) onChange;
  DateTime selectDate;

  TodayClassBuild(
      {Key key, @required this.snapshot, @required this.onChange, @required this.selectDate})
      :super(key: key);

  @override
  _TodayClassBuildState createState() => _TodayClassBuildState();
}

class _TodayClassBuildState extends State<TodayClassBuild> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true,
          children: [Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 32),
                child: Text("Today's Classes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Pick Date", style: TextStyle(fontSize: 18),),
                    FlatButton(onPressed: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          minTime: DateTime(2018, 3, 5),
                          maxTime: DateTime(DateTime
                              .now()
                              .year,
                              DateTime
                                  .now()
                                  .month,
                              DateTime
                                  .now()
                                  .day),
                          onConfirm: (date) {
                            setState(() {
                              widget.selectDate = date;
                            });

                            widget.onChange(date);
                          },
                          currentTime: widget.selectDate,
                          locale: LocaleType.en);
                    },
                      child: Text(
                        '${widget.selectDate.day}/${widget.selectDate
                            .month}/${widget.selectDate
                            .year}', style: TextStyle(color: Colors.blue),),),
                  ],),
              ),

              Column(
                children: List.generate(
                    widget.snapshot.data.length, (int index) {
                  return Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(title: Text(widget.snapshot
                          .data[index]['title']),
                        subtitle: Text(widget.snapshot
                            .data[index]['courseCode']),
                        leading: Container(color: (widget.snapshot
                            .data[index]['color'] == "#f00")
                            ? Colors.red
                            : (widget.snapshot.data[index]['color'] ==
                            "#4FCC4F") ? Colors.green : Colors.transparent,
                          width: 8,),
                        contentPadding: EdgeInsets.only(left: 0, right: 8),),
                    ],
                  );
                }),),
              Divider(),
            ],

          ),
          ]
      ),
    );
  }
}
















































