import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCourseBuilder extends StatefulWidget {
  final int semester;

  MyCourseBuilder(this.semester);

  @override
  _MyCourseBuilderState createState() => _MyCourseBuilderState();
}

class _MyCourseBuilderState extends State<MyCourseBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchMyCourses(widget.semester),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return MyCourseSeamer();
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
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var percentage =
                    double.tryParse("${snapshot.data[index]['percentage']}")
                        .roundToDouble();
                return Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 0,
                        right: 8,
                      ),
                      title: Text(
                        snapshot.data[index]['courseName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(snapshot.data[index]['courseCode']),
                      leading: Container(
                        color: (percentage < 75)
                            ? Colors.red
                            : (percentage >= 75 && percentage < 85)
                                ? Colors.yellow
                                : Colors.green,
                        width: 8,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "${snapshot.data[index]['present']}/${snapshot.data[index]['total']} "),
                          Text("(" + percentage.toString() + ")",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      onTap: () {},
                    ),
                    (index != snapshot.data.length - 1)
                        ? Divider()
                        : Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: Text(
                              "Tap a Course for more details",
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
        return Text("End"); // unreachable
      },
    );
  }
}

class MyCourseSeamer extends StatelessWidget {
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
