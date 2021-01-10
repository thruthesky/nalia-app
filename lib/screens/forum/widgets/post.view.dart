import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/screens/forum/widgets/post.view.files.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';

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
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Post No. ${post.id}, Author: ${post.authorName}'),
          Text('title: ${post.postTitle}'),
          Text('content: ${post.postContent}'),
          PostViewFiles(post: post),
          Row(
            children: [
              RaisedButton(
                child: Text('Edit'),
                onPressed: () {
                  if (post.isNotMine) return app.alert('not your post');
                  forum.editPost(post);
                },
              ),
              RaisedButton(
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
          )
        ],
      ),
    );
  }
}
