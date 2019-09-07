import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/material.dart';

class TodayClassBuilder extends StatefulWidget {
  final String start;
  final String end;

  TodayClassBuilder(this.start, this.end);

  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future:
          amizoneRepository.fetchTodayClassWithDate(widget.start, widget.end),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return TodayClassSeamer();
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null)
              return Center(child: Text('No classes for today'));
            //TODO:get from backend that this semester doesn't have data yet
            if (snapshot.data.toString() == "blah")
              return Center(
                  child: Text("This Semester Data doesnt exist for you"));
            //re make this
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    ListTile(

                      title: Text(snapshot.data[index]['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(snapshot.data[index]['courseCode']),
                      leading: Container(
                        color: (snapshot.data[index]['color'] == "#f00")
                            ? Colors.red
                            : (snapshot.data[index]['color'] == "#4FCC4F")
                            ? Colors.green
                            : Colors.transparent,
                        width: 8,
                      ),


                    ),
                    (index != snapshot.data.length - 1)
                        ? Divider()
                        : Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ))),
                  ],
                );
              },
            );
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(" "); // unreachable
      },
    );
  }
}

class TodayClassSeamer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey,
                    width: 200,
                    height: 20,
                  )),
              subtitle: Text(" "),
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(999)),
                height: 32,
                width: 32,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text(" "), Text(" ")],
              ),
              onTap: () {},
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
