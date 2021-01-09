import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/widgets/cache_image.dart';

class PostEditFormFiles extends StatefulWidget {
  const PostEditFormFiles({
    Key key,
    this.post,
  }) : super(key: key);

  final ApiPost post;

  @override
  _PostEditFormFilesState createState() => _PostEditFormFilesState();
}

class _PostEditFormFilesState extends State<PostEditFormFiles> {
  @override
  Widget build(BuildContext context) {
    if (widget.post.files.length == 0) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Uploaded files'),
        Divider(),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [
            for (ApiFile file in widget.post.files)
              Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    child: CacheImage(file.url),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  Positioned(
                    width: 50,
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0x77FFFFFF),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey[700],
                        ),
                      ),
                      onPressed: () async {
                        final re = await app.confirm(
                          'Delete Photo',
                          'Do you want to delete the photo?',
                        );
                        print('delete: $re');
                        if (re) {
                          try {
                            final id = await api.deleteFile(file.id,
                                post: widget.post);
                            setState(() => null);
                            print('deletedResult: $id');
                          } catch (e) {
                            app.error(e);
                          }
                        }
                      },
                    ),
                  )
                ],
              )
          ],
        ),
      ],
    );
  }
}
