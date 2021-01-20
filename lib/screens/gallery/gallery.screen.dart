import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/controllers/api.gallery.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/services/svg_icons.dart';
import 'package:nalia_app/widgets/cache_image.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/spinner.dart';
import 'package:nalia_app/widgets/svg_icon.dart';
import 'package:masonry_grid/masonry_grid.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  /// 갤러리 사진에 메뉴 버튼을 올리는 UI 작업
  List<Widget> buildPhotos(ApiPost post) {
    List<Widget> items = [];

    if (post == null) return [];
    Widget photoWidget;
    for (int i = 0; i < post.files.length; i++) {
      ApiFile photo = post.files[i];
      Widget item = ClipRRect(
        borderRadius: BorderRadius.circular(xxs),
        child: Stack(
          children: [
            CacheImage(photo.url),
            Positioned(
              bottom: 0,
              right: 0,
              child: PhotoGalleryPhotoMenu(photo),
            ),
            if (photo.id == post.featuredImageId)
              Positioned(
                top: 4,
                left: 4,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  color: Colors.white.withOpacity(0.7),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      MaterialCommunityIcons.crown,
                      color: Colors.yellow[800],
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

      // Primary photo 를 찾아 맨 앞에 표시
      if (photoWidget == null && photo.id == post.featuredImageId)
        photoWidget = item;
      else
        items.add(item);
    }
    if (photoWidget != null) {
      items.insert(0, photoWidget);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    /// TODO 위젯 rebuild 를 두번해서 화면이 flashign 된다. 처리 할 것.
    return Scaffold(
      appBar: CustomAppBar(
        route: RouteNames.gallery,
      ),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(child: GetBuilder<Gallery>(
        builder: (_) {
          // 사진 갤러리를 읽었는가?
          if (_.post == null) return Spinner();
          // 사진이 없다면,
          if (_.post.files.isEmpty) return AddPhoto(_.post.files);
          return Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(sm),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('사진: ${_.post.files.length} 개'),
                      PhotoUploadButton(_.post.files),
                    ],
                  ),
                  if (_.progress > 0)
                    LinearProgressIndicator(
                      minHeight: 3,
                      value: _.progress,
                    ),
                  spaceSm,
                  MasonryGrid(
                      column: 3,
                      mainAxisSpacing: xs,
                      crossAxisSpacing: xs,
                      children: buildPhotos(_.post)),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}

class PhotoUploadButton extends StatefulWidget {
  PhotoUploadButton(this.galleryPhotos);
  final List galleryPhotos;
  @override
  _PhotoUploadButtonState createState() => _PhotoUploadButtonState();
}

class _PhotoUploadButtonState extends State<PhotoUploadButton> {
  double uploadProgress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: Gallery.to.add,
      child: Text('사진 추가'),
    );
  }
}

// This is the type used by the popup menu below.
enum Choice { pin, delete }

class PhotoGalleryPhotoMenu extends StatelessWidget {
  PhotoGalleryPhotoMenu(this.photo);
  final ApiFile photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 48,
        height: 32,
        child: PopupMenuButton<Choice>(
          icon: Icon(
            FontAwesome5Solid.ellipsis_h,
            color: Colors.white,
            size: 18,
          ),
          padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 1),
          onSelected: (Choice choice) async {
            if (choice == Choice.delete) {
              Gallery.to.delete(photo.id);
            } else if (choice == Choice.pin) {
              Gallery.to.pin(photo);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
            const PopupMenuItem<Choice>(
              value: Choice.pin,
              child: ListTile(
                leading: Icon(Octicons.pin),
                title: Text('대표 사진 선택'),
              ),
            ),
            const PopupMenuItem<Choice>(
              value: Choice.delete,
              child: ListTile(
                leading: Icon(FontAwesome.times),
                title: Text('삭제'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPhoto extends StatefulWidget {
  AddPhoto(this.galleryPhotos);
  final List galleryPhotos;
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: Gallery.to.add,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIcon(
              picturesSvg,
              width: 100,
              height: 100,
            ),
            spaceLg,
            Text('앗, 사진을 추가해주세요 !'),
            spaceMd,
            Text(
              '사진 추가',
              style: TextStyle(color: Colors.blue),
            ),
            spaceXxl,
          ],
        ),
      ),
    );
  }
}
