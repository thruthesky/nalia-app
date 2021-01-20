import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.comment.model.dart';
import 'package:nalia_app/controllers/api.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/screens/forum/widgets/comment.form.dart';
import 'package:nalia_app/screens/forum/widgets/comment.list.dart';
import 'package:nalia_app/screens/forum/widgets/files.view.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/widgets/user_avatar.dart';

class PostView extends StatefulWidget {
  const PostView({
    Key key,
    this.forum,
    this.i,
  }) : super(key: key);

  final Forum forum;
  final int i;

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    Forum forum = widget.forum;
    ApiPost post = widget.forum.posts[widget.i];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(sm),
      padding: EdgeInsets.all(sm),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(post.featuredImageThumbnailUrl, size: 40),
              SizedBox(width: xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${post.authorName}',
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
                    Text('${post.shortDateTime}'),
                  ]),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: sm),
            child: Text('${post.postTitle}',
                style: TextStyle(
                  fontSize: md,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: sm),
            child: Text('${post.postContent}'),
          ),
          PostViewFiles(postOrComment: post),
          Divider(),
          Row(
            children: [
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
              if (post.isMine)
                TextButton(
                  child: Text('Edit'),
                  onPressed: () {
                    if (post.isNotMine) return app.alert('not your post');
                    forum.editPost(post);
                  },
                ),
              if (post.isMine)
                TextButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    try {
                      final re = await app.confirm(
                          'Delete', 'Do you want to delete the post?');
                      if (re == false) return;
                      final deletedId = await api.deletePost(post, forum);
                      print('deletedId: $deletedId');
                      forum.render();
                    } catch (e) {
                      app.error(e);
                    }
                  },
                ),
            ],
          ),
          CommentForm(
            post: post,
            forum: forum,
            comment: ApiComment(),
          ),
          CommentList(post: post, forum: forum),
        ],
      ),
    );
  }
}
