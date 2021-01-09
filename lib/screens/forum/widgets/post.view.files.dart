import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/widgets/cache_image.dart';

class PostViewFiles extends StatelessWidget {
  const PostViewFiles({
    Key key,
    this.post,
  }) : super(key: key);

  final ApiPost post;

  @override
  Widget build(BuildContext context) {
    if (post.files.length == 0) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Uploaded files'),
        Divider(),
        for (ApiFile file in post.files) CacheImage(file.url),
      ],
    );
  }
}
