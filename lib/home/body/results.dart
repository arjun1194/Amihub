import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';

class HomeResults extends StatefulWidget {
  @override
  _HomeResultsState createState() => _HomeResultsState();
}

class _HomeResultsState extends State<HomeResults> {
  @override
  Widget build(BuildContext context) {
    return ResultsBuilder();
  }
}

class ResultsBuilder extends StatefulWidget {
  @override
  _ResultsBuilderState createState() => _ResultsBuilderState();
}

class _ResultsBuilderState extends State<ResultsBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  int semester = 1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: amizoneRepository.fetchResultsWithSemester(semester),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ResultsSeamer();
          case ConnectionState.done:
            if (snapshot.hasError) return ResultsError();
            if (snapshot.data.elementAt(0) == "No Class")
              return ResultNotFound();
            return Container(child: ResultBuild(snapshot: snapshot));
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

class ResultBuild extends StatelessWidget {
  final AsyncSnapshot<List<dynamic>> snapshot;

  const ResultBuild({Key key, this.snapshot}) : super(key: key);

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
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Results",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  elevation: 8,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: width,
                    height: 0.35 * height,
                    child: Column(
                      children: <Widget>[


                        Container(color: Colors.green,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.home),
                              Text("Course"),


                            ],),
                        )


                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class ResultNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Result hasnt been uploaded yet");
  }
}

class ResultsError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text('Error Occured'),
    );
  }
}

class ResultsSeamer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: CircularProgressIndicator());
  }
}
