import 'dart:convert';
import 'dart:io';

import 'package:amihub/components/loader.dart';
import 'package:amihub/components/platform_specific.dart';
import 'package:amihub/models/review.dart';
import 'package:amihub/repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reviews extends StatefulWidget {
  final String contentId;
  final bool isCourse;

  Reviews({Key key, @required this.contentId, this.isCourse = false})
      : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  Future reviewFuture;
  AmizoneRepository _amizoneRepository = AmizoneRepository();

  @override
  void initState() {
    super.initState();
    reviewFuture = widget.isCourse
        ? _amizoneRepository.getCourseReviews(widget.contentId)
        : _amizoneRepository.getFacultyReviews(widget.contentId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: reviewFuture,
      builder: (context, AsyncSnapshot snapshot) {
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
                    child: Container(
                      child: Text(snapshot.error.toString()),
                    ),
                    padding: EdgeInsets.only(top: 50),
                  )
                : ReviewBuilder(
                    snapshot.data, widget.contentId, widget.isCourse);
        }
        return Text('end');
      },
    );
  }
}

class ReviewBuilder extends StatefulWidget {
  final dynamic response;
  final String contentId;

  final bool isCourse;

  ReviewBuilder(this.response, this.contentId, this.isCourse);

  @override
  _ReviewBuilderState createState() => _ReviewBuilderState();
}

class _ReviewBuilderState extends State<ReviewBuilder> {
  List<Widget> reviewsList;
  List<Review> reviews;
  int userId;
  int _numberOfReviews;
  AmizoneRepository _amizoneRepository = AmizoneRepository();

  _addAReview(Review review) {
    setState(() {
      reviewsList.insert(0, reviewWidget(review));
      _numberOfReviews++;
    });
  }

  Future<int> _getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("username");
  }

  @override
  void initState() {
    super.initState();
    _getUsername().then((val) {
      userId = val;
    });
    reviews = List.generate(widget.response["content"].length, (index) {
      var jsonResponse = widget.response["content"][index];
      return Review.fromJson(jsonResponse);
    });
    _numberOfReviews = widget.response["total"];
    reviewsList =
        List.generate(reviews.length, (index) => reviewWidget(reviews[index]));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Reviews  •  $_numberOfReviews'),
      initiallyExpanded: reviewsList.isEmpty ? true : false,
      children: [
        MyReview(widget.contentId, _addAReview, widget.isCourse),
      ]..addAll(reviewsList),
      leading: Icon(Icons.rate_review),
    );
  }

  Column reviewWidget(Review review) {
    return Column(
      key: Key(review.reviewId.toString()),
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
            isThreeLine: true,
            contentPadding: EdgeInsets.only(left: 8),
            dense: true,
            leading: ClipRRect(
              borderRadius: new BorderRadius.circular(24),
              child: Image.network(
                review.reviewerPhoto,
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
                    '${review.reviewerName}  •  ${DateFormat.yMMMEd().format(DateTime.fromMillisecondsSinceEpoch(review.timeStamp))}',
                    style:
                        TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                  ),
                ),
                Text(
                  review.review,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            trailing: PopupMenuButton<int>(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child:
                        Text(review.reviewerId == userId ? 'Delete' : 'Report'),
                    value: 0,
                  )
                ];
              },
              onSelected: (value) {
                _popUpButtonPressed(review);
              },
            ),
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
                    label: Text((review.upVotes == 0)
                        ? ''
                        : review.upVotes.toString())),
                FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_down,
                      size: 16,
                      color: Colors.grey,
                    ),
                    shape: StadiumBorder(),
                    label: Text((review.downVotes == 0)
                        ? ''
                        : review.downVotes.toString())),
              ],
            )),
        Divider()
      ],
    );
  }

  _popUpButtonPressed(Review review) {
    if (review.reviewerId == userId) {
      _amizoneRepository.deleteReview(review.reviewId).then((res) {
        if (res.statusCode == 202) {
          setState(() {
            reviewsList.removeWhere((element) {
              return element.key == Key(review.reviewId.toString());
            });
            _numberOfReviews--;
          });
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text('Review deleted'),
              duration: Duration(milliseconds: 1000)));
        }
        if (res.statusCode == 403) {
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text("You're not authorized to delete this review"),
              duration: Duration(milliseconds: 1500)));
        }
        if (res.statusCode == 404) {
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text('Review not found'),
              duration: Duration(milliseconds: 1500)));
        }
      }).catchError((err) {
        Scaffold.of(context).showSnackBar(platformSnackBar(
            content: Text("Error deleting review"),
            duration: Duration(milliseconds: 1500)));
      });
    } else {}
  }
}

class MyReview extends StatefulWidget {
  final String contentId;
  final Function(Review) addReview;
  final bool isCourse;

  MyReview(this.contentId, this.addReview, this.isCourse);

  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  AmizoneRepository _amizoneRepository = AmizoneRepository();
  TextEditingController _reviewController;
  String _userImagePath;
  bool _isSendingReview;

  _getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("username");
  }

  _setUserImagePath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    int username = await _getUsername();
    setState(() {
      _userImagePath = documentDirectory.path + '/images/$username.png';
    });
  }

  @override
  void initState() {
    super.initState();
    _setUserImagePath();
    _isSendingReview = false;
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Color getColor() {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff121212)
        : Colors.white;
  }

  _addReviewBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0.0))),
        backgroundColor: Colors.black,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return WillPopScope(
            onWillPop: _willPopScope,
            child: Container(
              color: getColor(),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            _userImagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.file(
                                      File(_userImagePath),
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Icon(Icons.person),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: getColor())),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: getColor())),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: getColor())),
                      contentPadding: EdgeInsets.only(left: 15),
                      alignLabelWithHint: false,
                      labelText: '',
                      hintText: 'Add a review...',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: _reviewController.text != null &&
                              _reviewController.text != ""
                          ? _isSendingReview
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: _reviewDoneButton)
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      counter: Container(
                        height: 0,
                        width: 0,
                      ),
                      isDense: true),
                  maxLength: 2000,
                  controller: _reviewController,
                  autofocus: true,
                  onSubmitted: (text) {
                    _reviewDoneButton();
                  },
                  maxLines: null,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 8),
            leading: _userImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      File(_userImagePath),
                      height: 48,
                      width: 48,
                      fit: BoxFit.fill,
                    ),
                  )
                : Icon(Icons.person),
            title: Text(
              'Add a review...',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
            onTap: _addReviewBottomSheet,
          ),
          Divider()
        ],
      ),
    );
  }

  _reviewDoneButton() {
    setState(() {
      _isSendingReview = true;
    });
    _amizoneRepository
        .createReview(widget.contentId, _reviewController.text,
            isCourse: widget.isCourse)
        .then((res) {
      if (res.statusCode == 201) {
        setState(() {
          _isSendingReview = false;
        });
        _reviewController.clear();
        Navigator.pop(context);
        var response = jsonDecode(res.body);
        Review review = Review.fromJson(response);
        widget.addReview(review);
      }
    }).catchError((err) {
      print(err.toString());
      _reviewController.clear();
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(platformSnackBar(
          content: Text("Can't submit review "),
          duration: Duration(milliseconds: 1500)));
    });
  }

  Future<bool> _willPopScope() {
    if (_reviewController.text != null && _reviewController.text != "") {
      Navigator.pop(context);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: new Text('Discard review?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _addReviewBottomSheet();
                  },
                  child: new Text(
                    'keep writing'.toUpperCase(),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                new FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    _reviewController.clear();
                    Navigator.of(context).pop(false);
                  },
                  child: new Text('discard'.toUpperCase()),
                ),
              ],
            );
          });
    }
    return Future.value(true);
  }
}
