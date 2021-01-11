import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.bio.model.dart';

import 'package:nalia_app/models/api.user.model.dart';
import 'package:nalia_app/widgets/user_avatar.dart';

class HomeUserCardSlideThumbnails extends StatefulWidget {
  HomeUserCardSlideThumbnails(this.user, {@required this.onClickThumbnail});
  final ApiBio user;
  final Function onClickThumbnail;
  @override
  _HomeUserCardSlideThumbnailsState createState() => _HomeUserCardSlideThumbnailsState();
}

class _HomeUserCardSlideThumbnailsState extends State<HomeUserCardSlideThumbnails> {
  List<String> photos = [];

  getUserGalleryPhotos() async {
    // final QuerySnapshot snapshot = await ff.postsCol
    //     .where('category', isEqualTo: USER_PHOTO_GALLERY)
    //     .where('uid', isEqualTo: widget.user.uid)
    //     .get();

    // for (final doc in snapshot.docs) {
    //   final data = doc.data();
    //   if (data[PRIMARY_PHOTO] == true) continue;

    //   /// 삭제된 사진은 뺀다.
    //   if (data['deletedAt'] != null) continue;

    //   photos.add(data['files'][0]);
    // }
  }

  init() async {
    await getUserGalleryPhotos();
    if (mounted) setState(() {});
    // print(photos);
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    double size = 48;

    if (photos.length == 0) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: size),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(4),
          color: photos.length < 5 ? Colors.transparent : Color(0x88777777),
          height: 240,
          width: size,
          child: ListView.builder(
            clipBehavior: Clip.none,
            itemCount: photos.length,
            itemBuilder: (_, i) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(2, 6, 2, 6),
                  child: UserAvatar(
                    photos[i],
                    size: 38,
                  ),
                ),
                onTap: () {
                  final _primary = widget.user.profilePhotoUrl;
                  widget.onClickThumbnail(photos[i]);
                  photos[i] = _primary;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
