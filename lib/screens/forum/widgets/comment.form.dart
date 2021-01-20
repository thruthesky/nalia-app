import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.comment.model.dart';
import 'package:nalia_app/controllers/api.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/screens/forum/widgets/files.form.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({
    Key key,
    @required this.post,
    this.parent,
    this.comment,
    @required this.forum,
  }) : super(key: key);

  /// post of the comment
  final ApiPost post;
  final ApiComment parent;
  final ApiComment comment;
  final Forum forum;

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final content = TextEditingController();

  /// [comment] to create or update
  ///
  /// Attention, the reason why it has a copy in state class is because
  /// when the app does hot reload(in development mode), the state disappears
  /// (like when file is uploaded and it disappears on hot reload).
  ApiComment comment;

  bool get canSubmit => content.text != '';
  double percentage = 0;

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
    content.text = comment.commentContent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                alignment: Alignment.center,
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  try {
                    final file = await app.imageUpload(
                        quality: 95, onProgress: (p) => setState(() => percentage = p));
                    print('file upload success: $file');
                    percentage = 0;
                    comment.files.add(file);
                    setState(() => null);
                  } catch (e) {
                    if (e == ERROR_IMAGE_NOT_SELECTED) {
                    } else {
                      app.error(e);
                    }
                  }
                },
              ),
              Expanded(
                child: TextFormField(
                    controller: content,
                    onChanged: (v) => setState(() => null),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: xs),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                      ),
                    )),
              ),
              if (canSubmit)
                IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    try {
                      final editedComment = await api.editComment(
                        content: content.text,
                        parent: widget.parent,
                        comment: comment,
                        post: widget.post,
                        files: comment.files,
                      );

                      widget.post.insertOrUpdateComment(editedComment);
                      content.text = '';
                      comment.files = [];
                      if (widget.parent != null)
                        widget.parent.mode = CommentMode.none;
                      if (widget.comment != null)
                        comment.mode = CommentMode.none;
                      setState(() => null);
                      widget.forum.render();
                      print('editeComment..: $editedComment');
                    } catch (e) {
                      app.error(e);
                    }
                  },
                ),
            ],
          ),
          FilesForm(postOrComment: comment),
        ],
      ),
    );
  }
}
