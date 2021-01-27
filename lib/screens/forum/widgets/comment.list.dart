import 'package:flutter/material.dart';
import 'package:nalia_app/screens/forum/widgets/comment.view.dart';
import 'package:firelamp/firelamp.dart';

class CommentList extends StatefulWidget {
  CommentList({
    this.post,
    this.forum,
  });
  final ApiPost post;
  final Forum forum;
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          for (ApiComment comment in widget.post.comments)
            CommentView(
              comment: comment,
              post: widget.post,
              forum: widget.forum,
            ),
        ],
      ),
    );
  }
}
