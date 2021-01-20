import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.comment.model.dart';
import 'package:nalia_app/controllers/api.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/screens/forum/widgets/comment.form.dart';
import 'package:nalia_app/screens/forum/widgets/files.view.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';

class CommentView extends StatefulWidget {
  const CommentView({
    Key key,
    this.comment,
    this.post,
    @required this.forum,
  }) : super(key: key);

  final ApiComment comment;
  final ApiPost post;
  final Forum forum;
  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: sm, left: sm * (widget.comment.depth - 1)),
      padding: EdgeInsets.all(sm),
      color: Colors.green[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.comment.mode == CommentMode.none ||
              widget.comment.mode == CommentMode.reply) ...[
            Text('Comment No.: ${widget.comment.commentId}'),
            Text('Comment Content: ${widget.comment.commentContent}'),
            PostViewFiles(postOrComment: widget.comment),
            Row(
              children: [
                RaisedButton(
                  child: Text('Reply'),
                  onPressed: () {
                    setState(() {
                      widget.comment.mode = CommentMode.reply;
                    });
                  },
                ),
                if (widget.comment.isMine)
                  RaisedButton(
                    child: Text('Edit'),
                    onPressed: () {
                      setState(() {
                        widget.comment.mode = CommentMode.edit;
                      });
                    },
                  ),
                if (widget.comment.isMine)
                  RaisedButton(
                    child: Text('Delete'),
                    onPressed: () async {
                      final re = await app.confirm('Delete', 'Do you want to delete the comment?');
                      if (re == false) return;
                      try {
                        final deleted = await api.deleteComment(widget.comment, widget.post);
                        print('deleted: $deleted');
                        widget.forum.render();
                      } catch (e) {
                        app.error(e);
                      }
                    },
                  ),
              ],
            ),
          ],
          if (widget.comment.mode == CommentMode.reply)
            CommentForm(
              parent: widget.comment,
              comment: ApiComment(),
              post: widget.post,
              forum: widget.forum,
            ),
          if (widget.comment.mode == CommentMode.edit)
            CommentForm(
              comment: widget.comment,
              post: widget.post,
              forum: widget.forum,
            ),
        ],
      ),
    );
  }
}
