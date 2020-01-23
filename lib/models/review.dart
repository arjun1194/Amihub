class Review {
  int reviewId;
  String contentId;
  String review;
  String reviewerName;
  String reviewerPhoto;
  int upVotes;
  int lastEdited;
  int downVotes;
  int timeStamp;

  Review(
      {this.reviewId,
        this.contentId,
        this.review,
        this.reviewerName,
        this.reviewerPhoto,
        this.upVotes,
        this.lastEdited,
        this.downVotes,
        this.timeStamp});

  Review.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    contentId = json['contentId'];
    review = json['review'];
    reviewerName = json['reviewerName'];
    reviewerPhoto = json['reviewerPhoto'];
    upVotes = json['upVotes'];
    lastEdited = json['lastEdited'];
    downVotes = json['downVotes'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewId'] = this.reviewId;
    data['contentId'] = this.contentId;
    data['review'] = this.review;
    data['reviewerName'] = this.reviewerName;
    data['reviewerPhoto'] = this.reviewerPhoto;
    data['upVotes'] = this.upVotes;
    data['lastEdited'] = this.lastEdited;
    data['downVotes'] = this.downVotes;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}