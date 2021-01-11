import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/services/global.dart';

class Gallery extends GetxController {
  static Gallery to = Get.find<Gallery>();
  static Gallery of = Get.find<Gallery>();
  ApiPost post;
  bool ready = false;
  double progress = 0;

  String get featuredImageUrl => post?.featuredImageUrl;
  @override
  void onInit() {
    super.onInit();

    api.authStateChanges.listen((user) async {
      try {
        post = await app.getGalleryPost();
        update();
      } catch (e) {
        app.error(e);
      }
    });
  }

  Future add() async {
    try {
      ApiFile file = await app.imageUpload(onProgress: (p) {
        progress = p;
        update();
      });
      progress = 0;
      post.files.add(file);
      post = await api.editPost(id: post.id, files: post.files);
      if (post.files.length == 1) {
        pin(post.files.first);
      }
      update();
    } catch (e) {
      app.error(e);
    }
  }

  Future delete(int id) async {
    try {
      await api.deleteFile(id, postOrComment: post);

      /// Set the first photo to be primary photo after the primary photo has deleted.
      if (post.featuredImageId == id && post.files.length > 0) {
        pin(post.files.first);
      } else {
        // if there is no more photo, remove user avatar.
        post.featuredImageId = 0;
        post.featuredImageUrl = null;
        post.featuredImageThumbnailUrl = null;
      }
      update();
    } catch (e) {
      app.error(e);
    }
  }

  /// Set primary photo
  Future pin(ApiFile photo) async {
    if (post.featuredImageId == photo.id) {
      app.alert('The photo is already set as primary photo'.tr);
      return;
    }
    try {
      await api.setFeaturedImage(post, photo);
      post.featuredImageId = photo.id;
      post.featuredImageUrl = photo.url;
      post.featuredImageThumbnailUrl = photo.thumbnailUrl;
      update();
    } catch (e) {
      app.error(e);
    }
  }
}
