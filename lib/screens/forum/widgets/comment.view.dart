import 'package:flutter/material.dart';
import 'package:nalia_app/screens/forum/widgets/comment.form.dart';
import 'package:nalia_app/screens/forum/widgets/files.view.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/widgets/user_avatar.dart';
import 'package:firelamp/firelamp.dart';

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
  /// when user is done selecting from the popup menu.
  onPopupMenuItemSelected(selected) async {
    /// Edit
    if (selected == 'edit') {
      setState(() {
        widget.comment.mode = CommentMode.edit;
      });
    }

    /// Delete
    if (selected == 'delete') {
      bool conf = await app.confirm(
        'Confirm',
        'Delete Comment?',
      );
      if (conf == false) return;

      try {
        final deleted = await api.deleteComment(widget.comment, widget.post);
        print('deleted: $deleted');
        widget.forum.render();
      } catch (e) {
        app.error(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: sm, left: sm * (widget.comment.depth - 1)),
      padding: EdgeInsets.all(sm),
      decoration: BoxDecoration(
        // color: Colors.blueGrey[50],
        color: Color(0x338fb1cc),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(widget.comment.userPhoto, size: 40),
              SizedBox(width: xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.comment.commentAuthor}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: sm,
                      )),
                  Row(children: [
                    Icon(
                      Icons.circle,
                      size: xxs,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: xs),
                    Text('${widget.comment.shortDateTime}'),
                  ]),
                ],
              ),
              if (widget.comment.mode == CommentMode.edit) ...[
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      widget.comment.mode = CommentMode.none;
                    });
                  },
                ),
              ]
            ],
          ),
          if (widget.comment.mode == CommentMode.none || widget.comment.mode == CommentMode.reply) ...[
            if (widget.comment.commentContent.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: sm),
                child: SelectableText('${widget.comment.commentContent}'),
              ),
            PostViewFiles(postOrComment: widget.comment),
            Divider(),
            Row(children: [
              TextButton(
                child: Text(widget.comment.mode == CommentMode.reply ? 'Cancel' : 'Reply'),
                onPressed: () {
                  setState(() {
                    widget.comment.mode =
                        widget.comment.mode == CommentMode.reply ? CommentMode.none : CommentMode.reply;
                  });
                },
              ),
              TextButton(
                child: Text('Like'),
                onPressed: () {
                  // TODO: VOTE
                  print('TODO: LIKE');
                },
              ),
              TextButton(
                child: Text('Dislike'),
                onPressed: () {
                  // TODO: VOTE
                  print('TODO: DISLIKE');
                },
              ),
              Spacer(),
              if (widget.comment.isMine)
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Row(children: [
                          Icon(Icons.edit, size: sm, color: Colors.greenAccent),
                          SizedBox(width: xs),
                          Text('Edit')
                        ]),
                        value: 'edit'),
                    PopupMenuItem(
                        child: Row(children: [
                          Icon(Icons.delete, size: sm, color: Colors.redAccent),
                          SizedBox(width: xs),
                          Text('Delete')
                        ]),
                        value: 'delete')
                  ],
                  icon: Icon(Icons.more_vert),
                  offset: Offset(10.0, 10.0),
                  onSelected: onPopupMenuItemSelected,
                ),
            ]),
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
