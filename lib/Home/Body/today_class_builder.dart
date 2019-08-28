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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Some error has occured Please try again later!"),
                  RaisedButton(
                    child: Text("Retry"),
                    onPressed: () {
                      setState(() {});
                    },
                  )
                ],
              );
            //TODO:get from backend that this semester doesn't have data yet
            if (snapshot.data == "blah")
              return Center(
                  child: Text("This Semester Data doesnt exist for you"));
            //re make this
            return Text("${snapshot.data}");
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
