import 'package:nalia_app/models/api.comment.model.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/services/global.dart';

class ApiPost {
  ApiPost({
    this.id,
    this.postAuthor,
    this.postDate,
    this.postContent,
    this.postTitle,
    this.postModified,
    this.postParent,
    this.guid,
    this.commentCount,
    this.postCategory,
    this.files,
    this.authorName,
    this.shortDateTime,
    this.comments,
    this.category,
  }) {
    if (files == null) files = [];
    if (postTitle == null) postTitle = '';
    if (postContent == null) postContent = '';
  }

  int id;
  String postAuthor;
  DateTime postDate;
  String postContent;
  String postTitle;
  DateTime postModified;
  int postParent;
  String guid;
  String commentCount;
  List<int> postCategory;
  List<ApiFile> files;
  String authorName;
  String shortDateTime;
  List<ApiComment> comments;
  String category;
  bool get isMine => postAuthor == api.id;
  bool get isNotMine => !isMine;

  insertOrUpdateComment(ApiComment comment) {
    // if it's new comment right under post, then add at bottom.
    if (comment.commentParent == '0') {
      comments.add(comment);
      print('parent id: 0, add at bottom');
      return;
    }

    // find existing comment and update.
    int i = comments.indexWhere((c) => c.commentId == comment.commentId);
    if (i != -1) {
      comment.depth = comments[i].depth;
      comments[i] = comment;
      return;
    }

    // find parent and add below the parent.
    int p = comments.indexWhere((c) => c.commentId == comment.commentParent);
    if (p != -1) {
      comment.depth = comments[p].depth + 1;
      comments.insert(p + 1, comment);
      return;
    }

    // error. code should not come here.
    print('error on comment add:');
  }

  factory ApiPost.fromJson(Map<String, dynamic> json) => ApiPost(
        id: json["ID"],
        postAuthor: json["post_author"],
        postDate: DateTime.parse(json["post_date"]),
        postContent: json["post_content"],
        postTitle: json["post_title"],
        postModified: DateTime.parse(json["post_modified"]),
        postParent: json["post_parent"],
        guid: json["guid"],
        commentCount: json["comment_count"],
        postCategory: List<int>.from(json["post_category"].map((x) => x)),
        files:
            List<ApiFile>.from(json["files"].map((x) => ApiFile.fromJson(x))),
        authorName: json["author_name"],
        shortDateTime: json["short_date_time"],
        comments: List<ApiComment>.from(
            json["comments"].map((x) => ApiComment.fromJson(x))),
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "post_author": postAuthor,
        "post_date": postDate.toIso8601String(),
        "post_content": postContent,
        "post_title": postTitle,
        "post_modified": postModified.toIso8601String(),
        "post_parent": postParent,
        "guid": guid,
        "comment_count": commentCount,
        "post_category": List<dynamic>.from(postCategory.map((x) => x)),
        "files": List<dynamic>.from(files.map((x) => x.toJson().toString())),
        "author_name": authorName,
        "short_date_time": shortDateTime,
        "comments":
            List<dynamic>.from(comments.map((x) => x.toJson().toString())),
        "category": category,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
