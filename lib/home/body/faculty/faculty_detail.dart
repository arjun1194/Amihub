import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/models/review.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/models/profile.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';

class FacultyDetail extends StatefulWidget {
  final String facultyCode;
  final String facultyName;

  FacultyDetail({@required this.facultyCode, @required this.facultyName});

  @override
  _FacultyDetailState createState() => _FacultyDetailState();
}

class _FacultyDetailState extends State<FacultyDetail> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: amizoneRepository.getFacultyInfo(widget.facultyCode),
      builder: (context, AsyncSnapshot<FacultyInfo> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Loader();
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return (snapshot.hasError || snapshot.data == null)
                ? Padding(
                    child: ErrorPage(),
                    padding: EdgeInsets.only(top: 50),
                  )
                : FacultyDetailBuild(
                    snapshot: snapshot,
                  );
        }
        return Text('end');
      },
    ));
  }
}

class FacultyDetailBuild extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;

  FacultyDetailBuild({Key key, @required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverAppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          floating: true,
          pinned: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more_vert), onPressed: () => {})
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            FacultyDetails(snapshot, width),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            ContactActions(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            CoursesList(
              snapshot: snapshot,
            ),
            Reviews(facultyCode: snapshot.data.facultyCode),
          ]),
        ),
      ],
    );
  }
}

class FacultyDetails extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;
  double width;

  FacultyDetails(this.snapshot, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              height: 100,
              width: 100,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey[500])
              ]),
              child: Image.network(
                snapshot.data.facultyImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width - 132,
                child: Text(
                  snapshot.data.facultyName,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: width - 132,
                child: Text(
                  snapshot.data.department,
                  style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactActions extends StatelessWidget {
  Widget actionButton(text, iconData) {
    return FlatButton(
      onPressed: () => {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.blue,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        actionButton(
          'Phone',
          Icons.phone,
        ),
        actionButton(
          'Email',
          Icons.email,
        ),
        actionButton(
          'Place',
          Icons.place,
        ),
      ],
    );
  }
}

class CoursesList extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;

  CoursesList({this.snapshot});

  List<Widget> courseChips() {
    List<Widget> chips = [];
    snapshot.data.courses.forEach((course) {
      chips.add(Chip(
        label: Text(course.name),
      ));
    });
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: (this.snapshot.data.courses.length == 0)
          ? Text('')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Courses',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: courseChips(),
                )
              ],
            ),
    );
  }
}

class Reviews extends StatefulWidget {
  final String facultyCode;

  Reviews({Key key, @required this.facultyCode}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AmizoneRepository().getFacultyReviews(widget.facultyCode),
      builder: (context, AsyncSnapshot<List<Review>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Text('Loading...');
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return (snapshot.hasError)
                ? Padding(
                    child: Text(snapshot.error.toString()),
                    padding: EdgeInsets.only(top: 50),
                  )
                : ReviewBuilder(snapshot, widget.facultyCode);
        }
        return Text('end');
      },
    );
  }
}

class ReviewBuilder extends StatelessWidget {
  AsyncSnapshot<List<Review>> snapshot;
  String facultyCode;
  int upvotes;
  int downvotes;

  ReviewBuilder(this.snapshot, this.facultyCode);

  @override
  Widget build(BuildContext context) {
    List<Widget> reviews = List.generate(
        snapshot.data.length,
        (index) => Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left: 8),
                  leading: ClipRRect(
                    borderRadius: new BorderRadius.circular(9999.0),
                    child: Image.network(
                      snapshot.data[index].reviewerPhoto,
                      fit: BoxFit.fill,
                      height: 64.0,
                      width: 60.0,
                    ),
                  ),
                  title: Text(
                    snapshot.data[index].reviewerName,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  subtitle: Text(snapshot.data[index].review,
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 80),
                  height: 32,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton.icon(
                          onPressed: () {},
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.thumb_up,
                            size: 16,
                            color: Colors.grey,
                          ),
                          label: Text((snapshot.data[index].upVotes == 0)
                              ? ''
                              : snapshot.data[index].upVotes)),
                      FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.thumb_down,
                            size: 16,
                            color: Colors.grey,
                          ),
                          label: Text((snapshot.data[index].downVotes == 0)
                              ? ''
                              : snapshot.data[index].downVotes)),
                    ],
                  ),
                )
              ],
            ));
    //reviews.add();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Text(
                'Reviews',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  (snapshot.data.length == 0)
                      ? ''
                      : snapshot.data.length.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        MyReview(facultyCode),
        ...reviews,
      ],
    );
  }
}

class MyReview extends StatefulWidget {
  String facultyCode;

  MyReview(this.facultyCode);

  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  TextEditingController myController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     myController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AmizoneRepository().fetchMyProfile(),
      builder: (context, AsyncSnapshot<Profile> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Loader();
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasError) return Text('${snapshot.error}');
            return ListTile(
              contentPadding: EdgeInsets.only(left: 8),
              leading: ClipRRect(
                borderRadius: new BorderRadius.circular(9999.0),
                child: Image.network(
                  snapshot.data.photo,
                  fit: BoxFit.fill,
                  height: 64.0,
                  width: 60.0,
                ),
              ),
              title: Text(
                snapshot.data.name,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              subtitle: TextField(
                controller: myController,
              ),
              trailing: IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    AmizoneRepository()
                        .createReview(widget.facultyCode, myController.text).then((res){
                         setState(() {

                         });
                    });
                  }),
            );
        }
        return Text('end');
      },
    );
  }
}
