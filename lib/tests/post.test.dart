// import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:firelamp/firelamp.dart';

class PostTest {
  run() async {
    // postCrud();
    postCommmentCrudWithTwoPhotos();
  }

  /// This tests post crud & comment crud with two photos.
  /// And reading post & comment test.
  Future<ApiPost> postCommmentCrudWithTwoPhotos() async {
    /// Update photo no. 1
    final file1 = await app.imageUpload(
        quality: 95,
        onProgress: (int p) {
          print('Progress: $p');
        });

    /// upload photo no 2.
    final file2 = await app.imageUpload(
        quality: 95,
        onProgress: (int p) {
          print('Progress: $p');
        });

    /// Create a post with the photos.
    int stamp = DateTime.now().millisecondsSinceEpoch;
    final post = await api.editPost(
      category: 'reminder',
      title: 'Title $stamp',
      content: 'Content: $stamp',
      files: [file1, file2],
    );

    return await api.getPost(post.id);

    /// Create a comment of under the post.
  }
}
