import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nalia_app/screens/forum/widgets/files.form.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:firelamp/firelamp.dart';

class PostForm extends StatefulWidget {
  PostForm(this.forum);

  final Forum forum;
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final title = TextEditingController();
  final content = TextEditingController();
  double percentage = 0;
  ApiPost post;

  InputDecoration _inputDecoration = InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.all(sm),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    print('_PostFormState::initState()');
    post = widget.forum.postInEdit;
    title.text = post.postTitle;
    content.text = post.postContent;
  }

  @override
  Widget build(BuildContext context) {
    Forum forum = widget.forum;

    if (forum.postInEdit == null) return SizedBox.shrink();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(sm),
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: xs, bottom: xs),
              child: Text('title'.tr),
            ),
            TextFormField(
              controller: title,
              decoration: _inputDecoration,
            ),
            Padding(
              padding: EdgeInsets.only(top: md, bottom: xs),
              child: Text('content'.tr),
            ),
            TextFormField(
              controller: content,
              minLines: 5,
              maxLines: 15,
              decoration: _inputDecoration,
            ),
            FilesForm(postOrComment: forum.postInEdit),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      // Text('Photo' + (percentage > 0 ? "$percentage%" : "")),
                      onPressed: () async {
                        try {
                          final file = await app.imageUpload(
                              quality: 95, onProgress: (p) => setState(() => percentage = p));
                          print('file upload success: $file');
                          percentage = 0;
                          post.files.add(file);
                          setState(() => null);
                        } catch (e) {
                          if (e == ERROR_IMAGE_NOT_SELECTED) {
                          } else {
                            app.error(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
                if (percentage > 0)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: sm),
                      child: LinearProgressIndicator(value: percentage),
                    ),
                  ),
                Row(
                  children: [
                    FlatButton(
                      child: Text('Create'),
                      color: Colors.green[300],
                      onPressed: () async {
                        try {
                          /// TODO move it into forum model
                          final editedPost = await api.editPost(
                            id: post.id,
                            category: forum.category,
                            title: title.text,
                            content: content.text,
                            files: post.files,
                          );
                          forum.insertOrUpdatePost(editedPost);
                          // reset();
                        } catch (e) {
                          app.error(e);
                        }
                      },
                    ),
                    // RaisedButton(
                    //   child: Text('Cancel'),
                    //   onPressed: () {
                    //     forum.editPost(null);
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
