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
  String _userImagePath;
  TextEditingController _reviewController;
  bool _isSendingReview;
  int _currentReviewPage = 0;
  AmizoneRepository _amizoneRepository = AmizoneRepository();

  _addReview(Review review) {
    setState(() {
      reviewsList.insert(0, reviewWidget(review));
      _numberOfReviews++;
    });
  }

  _editReview(Review review) {
    _reviewController.text = review.review;
    _addReviewBottomSheet(isEdit: true, review: review);
  }

  Future<int> _getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("username");
  }

  _setUserImagePath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    userId = await _getUsername();
    _userImagePath = documentDirectory.path + '/images/$userId.png';
  }

  @override
  void initState() {
    super.initState();
    _setUserImagePath();
    _isSendingReview = false;
    _reviewController = TextEditingController();
    reviews = List.generate(widget.response["content"].length, (index) {
      var jsonResponse = widget.response["content"][index];
      return Review.fromJson(jsonResponse);
    });
    _numberOfReviews = widget.response["total"];
    reviewsList =
        List.generate(reviews.length, (index) => reviewWidget(reviews[index]));
    reviewsList.add(widget.response["last"]
        ? Container()
        : RaisedButton(
            key: Key("load"),
            child: Text("load more".toUpperCase()),
            onPressed: _requestMoreReviews,
            shape: StadiumBorder(),
          ));
  }

  Future _getMoreReviews() {
    return widget.isCourse
        ? _amizoneRepository.getCourseReviews(widget.contentId,
            page: _currentReviewPage + 1)
        : _amizoneRepository.getFacultyReviews(widget.contentId,
            page: _currentReviewPage + 1);
  }

  _requestMoreReviews() {
    _getMoreReviews().then((res) {
      if (res["content"] != null) {
        (res["content"] as List).forEach((f) {
          reviewsList.add(reviewWidget(Review.fromJson(f)));
        });
        reviewsList.removeWhere((f) => f.key == Key("load"));
        if (!res["last"])
          reviewsList.add(RaisedButton(
            key: Key("load"),
            child: Text("load more".toUpperCase()),
            onPressed: _requestMoreReviews,
            shape: StadiumBorder(),
          ));
        setState(() {});
        _currentReviewPage++;
      } else {
        Scaffold.of(context).showSnackBar(platformSnackBar(
            content: Text("Can't load more review"),
            duration: Duration(milliseconds: 1500)));
      }
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(platformSnackBar(
          content: Text("Can't load more review"),
          duration: Duration(milliseconds: 1500)));
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Reviews  •  $_numberOfReviews'),
      initiallyExpanded: reviewsList.length == 1 ? true : false,
      children: [
        UserReview(
          openBottomSheet: _addReviewBottomSheet,
          hasDivider: reviewsList.length != 1,
        )
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
                    '${review.reviewerName}  •  ${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(review.lastEdited))}',
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
                return review.reviewerId == userId
                    ? [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 0,
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 1,
                        )
                      ]
                    : [
                        PopupMenuItem(
                          child: Text('Report'),
                          value: 3,
                        )
                      ];
              },
              onSelected: (value) {
                if (value == 0)
                  _editReview(review);
                else
                  _popUpButtonPressed(review);
              },
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                FlatButton.icon(
//                    onPressed: () {},
//                    shape: StadiumBorder(),
//                    icon: Icon(
//                      Icons.thumb_up,
//                      size: 16,
//                      color: Colors.grey,
//                    ),
//                    label: Text((review.upVotes == 0)
//                        ? ''
//                        : review.upVotes.toString())),
//                FlatButton.icon(
//                    onPressed: () {},
//                    icon: Icon(
//                      Icons.thumb_down,
//                      size: 16,
//                      color: Colors.grey,
//                    ),
//                    shape: StadiumBorder(),
//                    label: Text((review.downVotes == 0)
//                        ? ''
//                        : review.downVotes.toString())),
//                SizedBox(width: 5,),
                Text(
                  review.timeStamp == review.lastEdited ? "" : "Edited",
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                )
              ],
            )),
        Divider()
      ],
    );
  }

  _popUpButtonPressed(Review review) {
    if (review.reviewerId == userId) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: new Text('Delete review'),
              content: Text("Delete your review permanently?"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                    'cancel'.toUpperCase(),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                new FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteReview(review);
                  },
                  child: new Text('delete'.toUpperCase()),
                ),
              ],
            );
          });
    } else {
      _amizoneRepository.reportReview(review.reviewId).then((res) {
        if (res.statusCode == 423) {
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text("Review Service is currently down"),
              duration: Duration(milliseconds: 1500)));
        }
        if (res.statusCode == 304) {
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text("This review is already flagged"),
              duration: Duration(milliseconds: 1500)));
        }
        if (res.statusCode == 404) {
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text('Review not found'),
              duration: Duration(milliseconds: 1500)));
        }
        if (res.statusCode == 202) {
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text("Thanks for reporting"),
              duration: Duration(milliseconds: 1000)));
        }
      }).catchError((err) {
        Scaffold.of(context).showSnackBar(platformSnackBar(
            content: Text("Error reporting review"),
            duration: Duration(milliseconds: 1500)));
      });
    }
  }

  _deleteReview(Review review) {
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
      if (res.statusCode == 423) {
        Scaffold.of(context).showSnackBar(platformSnackBar(
            content: Text("Review Service is currently down"),
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
  }

  _addReviewBottomSheet({bool isEdit = false, Review review}) {
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
                      suffixIcon: _isSendingReview
                          ? Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(),
                            )
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
                    isEdit ? _reviewEditDone(review) : _reviewDoneButton();
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

  _reviewEditDone(Review review) {
    if (_reviewController.text == "") {
      Navigator.pop(context);
    } else {
      setState(() {
        _isSendingReview = true;
      });
      _amizoneRepository
          .editReview(review.reviewId, _reviewController.text)
          .then((res) {
        setState(() {
          _isSendingReview = false;
        });
        if (res.statusCode == 202) {
          _reviewController.clear();
          Navigator.pop(context);
          var response = jsonDecode(res.body);
          Review r1 = Review.fromJson(response);
          reviewsList.removeWhere((element) {
            return element.key == Key(review.reviewId.toString());
          });
          _numberOfReviews--;
          _addReview(r1);
        }
        if (res.statusCode == 423) {
          _reviewController.clear();
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text("Review Service is currently down"),
              duration: Duration(milliseconds: 1500)));
        }
      }).catchError((err) {
        print(err.toString());
        _reviewController.clear();
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(platformSnackBar(
            content: Text("Can't edit review "),
            duration: Duration(milliseconds: 1500)));
      });
    }
  }

  Color getColor() {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff121212)
        : Colors.white;
  }

  _reviewDoneButton() {
    if (_reviewController.text == "") {
      Navigator.pop(context);
    } else {
      setState(() {
        _isSendingReview = true;
      });
      _amizoneRepository
          .createReview(widget.contentId, _reviewController.text,
              isCourse: widget.isCourse)
          .then((res) {
        setState(() {
          _isSendingReview = false;
        });
        if (res.statusCode == 201) {
          _reviewController.clear();
          Navigator.pop(context);
          var response = jsonDecode(res.body);
          Review review = Review.fromJson(response);
          _addReview(review);
        }
        if (res.statusCode == 423) {
          _reviewController.clear();
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(platformSnackBar(
              content: Text("Review Service is currently down"),
              duration: Duration(milliseconds: 1500)));
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

class UserReview extends StatefulWidget {
  final VoidCallback openBottomSheet;
  final bool hasDivider;

  const UserReview({Key key, this.openBottomSheet, this.hasDivider})
      : super(key: key);

  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {
  String _userImagePath;

  Future<int> _getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("username");
  }

  _setUserImagePath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    int userId = await _getUsername();
    setState(() {
      _userImagePath = documentDirectory.path + '/images/$userId.png';
    });
  }

  @override
  void initState() {
    super.initState();
    _setUserImagePath();
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
            onTap: widget.openBottomSheet,
          ),
          widget.hasDivider ? Divider() : Container()
        ],
      ),
    );
  }
}
