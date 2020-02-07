import 'package:amihub/components/error.dart';
import 'package:amihub/components/loader.dart';
import 'package:amihub/components/page_heading.dart';
import 'package:amihub/models/review.dart';
import 'package:amihub/models/faculty_info.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
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
                    child: ErrorPage(snapshot.error),
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
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black, //change your color here
          ),
          backgroundColor: blackOrWhite(context),
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
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
  final double width;

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
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey[500])
                ]),
                child: Image.network(
                  snapshot.data.facultyImage,
                  fit: BoxFit.fill,
                ),
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
              SizedBox(
                height: 8,
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
  Widget actionButton(text, iconData, onPressed) {
    return FlatButton(
      shape: CircleBorder(),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.blue,
            ),
            SizedBox(
              height: 4,
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
        actionButton('Phone', Icons.phone, () {}),
        actionButton('Email', Icons.email, () {}),
        actionButton('Cabin', Icons.place, () {}),
      ],
    );
  }
}

class CoursesList extends StatelessWidget {
  final AsyncSnapshot<FacultyInfo> snapshot;

  CoursesList({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: (this.snapshot.data.courses.length == 0)
          ? Text('')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PageHeader('Courses'),
                SizedBox(
                  height: 4,
                ),
                Wrap(
                  spacing: 5,
                  children: snapshot.data.courses.map((course) {
                    return Chip(label: Text(course.name));
                  }).toList(),
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
            return Center(child: Loader());
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return (snapshot.hasError)
                ? Padding(
                    child: Text(snapshot.error.toString()),
                    padding: EdgeInsets.only(top: 50),
                  )
                : ReviewBuilder(snapshot.data, widget.facultyCode);
        }
        return Text('end');
      },
    );
  }
}

class ReviewBuilder extends StatelessWidget {
  final List<Review> reviews;
  final String facultyCode;

  ReviewBuilder(this.reviews, this.facultyCode);

  @override
  Widget build(BuildContext context) {
    List<Widget> reviewsList = List.generate(
        reviews.length,
        (index) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                    isThreeLine: true,
                    contentPadding: EdgeInsets.only(left: 8),
                    dense: true,
                    leading: ClipRRect(
                      borderRadius: new BorderRadius.circular(24),
                      child: Image.network(
                        reviews[index].reviewerPhoto,
                        fit: BoxFit.cover,
                        height: 48.0,
                        width: 48.0,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            reviews[index].reviewerName,
                            style: TextStyle(
                                fontSize: 13.5, color: Colors.grey.shade700),
                          ),
                        ),
                        Text(
                          reviews[index].review,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.more_vert), onPressed: () {}),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FlatButton.icon(
                            onPressed: () {},
                            shape: StadiumBorder(),
                            icon: Icon(
                              Icons.thumb_up,
                              size: 16,
                              color: Colors.grey,
                            ),
                            label: Text((reviews[index].upVotes == 0)
                                ? ''
                                : reviews[index].upVotes.toString())),
                        FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.thumb_down,
                              size: 16,
                              color: Colors.grey,
                            ),
                            shape: StadiumBorder(),
                            label: Text((reviews[index].downVotes == 0)
                                ? ''
                                : reviews[index].downVotes.toString())),
                      ],
                    )),
              ],
            ));
    //reviews.add();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              reviews.length != 0 ? PageHeader('Reviews') : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  (reviews.length == 0) ? '' : reviews.length.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              )
            ],
          ),
        ),
        MyReview(facultyCode),
        ...reviewsList,
      ],
    );
  }
}

class MyReview extends StatefulWidget {
  final String facultyCode;

  MyReview(this.facultyCode);

  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  TextEditingController myController;

  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();

//    return ListTile(
//      contentPadding: EdgeInsets.only(left: 8),
//      leading: ClipRRect(
//        borderRadius: new BorderRadius.circular(9999.0),
//        child: Image.file(File(imageData), fit: BoxFit.fitWidth)
//      ),
//      title: Text(
//        name,
//        style: TextStyle(fontSize: 10, color: Colors.grey),
//      ),
//      subtitle: TextField(
//        controller: myController,
//      ),
//      trailing: IconButton(
//          icon: Icon(Icons.send, color: Colors.blueAccent),
//          onPressed: () {
//            AmizoneRepository()
//                .createReview(widget.facultyCode, myController.text)
//                .then((res) {
//              setState(() {});
//            });
//          }),
//    );
  }
}
