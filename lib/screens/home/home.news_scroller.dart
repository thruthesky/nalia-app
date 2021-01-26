import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/widgets/user_avatar.dart';
import 'package:text_scroller/text_scroller.dart';
import 'package:get/get.dart';
import 'package:withcenter/withcenter.dart';

class HomeNewsScroller extends StatefulWidget {
  const HomeNewsScroller({Key key}) : super(key: key);
  @override
  _HomeNewsScrollerState createState() => _HomeNewsScrollerState();
}

class _HomeNewsScrollerState extends State<HomeNewsScroller> {
  final textScrollController = TextScrollController();
  StreamSubscription notificationSubscription;

  Widget buildRecommendedSticker(data) {
    Widget item = SizedBox.shrink();
    Widget otherUser = SizedBox.shrink();
    String text = '';
    String toUid = data['toUid'];
    if (toUid == withcenterApi.id) {
      otherUser = UserAvatar(
        data['fromPhotoURL'],
        size: 22,
      );
    } else {
      otherUser = UserAvatar(
        data['toPhotoURL'],
        size: 22,
      );
    }

    if (data['jewelry'] == DIAMOND) {
      item = Icon(
        FontAwesome5Solid.gem,
        color: Colors.white,
        size: 20,
      );
      if (toUid == withcenterApi.id)
        text = 'diamond recv'.tr;
      else
        text = 'diamond send'.tr;
    } else if (data['jewelry'] == SILVER) {
      item = Icon(
        FontAwesome5Solid.heart,
        color: Colors.deepOrange[400],
        size: md - 2,
      );
      if (toUid == withcenterApi.id)
        text = 'silver recv'.tr;
      else
        text = 'silver send'.tr;
    } else if (data['item'] == WATCH) {
      item = Icon(
        Feather.watch,
        color: Colors.lime[500],
        size: md,
      );
      if (toUid == withcenterApi.id) {
        text = 'watch recv'.tr;
      } else {
        text = 'watch send'.tr;
      }
    } else if (data['item'] == RING) {
      item = Icon(
        MaterialCommunityIcons.ring,
        color: Colors.yellow[700],
        size: md + 3,
      );
      if (toUid == withcenterApi.id)
        text = 'ring recv'.tr;
      else
        text = 'ring send'.tr;
    } else if (data['item'] == BAG) {
      item = Icon(
        SimpleLineIcons.handbag,
        color: Colors.yellow[200],
        size: md - 2,
      );
      if (toUid == withcenterApi.id)
        text = 'bag recv'.tr;
      else
        text = 'bag send'.tr;
    }
    Widget widget = RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        children: [
          WidgetSpan(child: otherUser, alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: spaceXxs),
          WidgetSpan(child: item, alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: spaceXxs),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
              constraints: BoxConstraints(maxWidth: 180),
              decoration: BoxDecoration(
                color: Color(0x77cccccc),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
    return widget;
  }

  Widget buildTextSticker(str) {
    Widget text = RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              constraints: BoxConstraints(maxWidth: 180),
              color: Color(0xaacccccc),
              child: Text(
                str,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
        ],
      ),
    );
    return text;
  }

  // int c = 0;
  @override
  void initState() {
    super.initState();
    // print('initState()');

    // notificationSubscription = app.firestoreNotificationChanges.listen((data) {
    //   print('NewScroller => initState => app.firestoreNotifcationChange => $data');
    //   if (data['message'] != null) {
    //     textScrollController.add(buildTextSticker(data['message']));
    //   } else {
    //     Widget text = SizedBox.shrink();
    //     if (data['type'] == 'recommend') {
    //       text = buildRecommendedSticker(data);
    //     }
    //     textScrollController.add(text);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    if (notificationSubscription != null) notificationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 120,
      right: 0,
      child: Container(
        margin: EdgeInsets.only(right: 6.0),
        child: TextScroller(
          controller: textScrollController,
          style: TextStyle(fontSize: 11),
          height: 112,
          width: 180,
          lineHeight: 26,
          backgroundColor: Color(0x44cccccc),
          textRemovalSpeed: Duration(seconds: 80),
        ),
      ),
    );
  }
}
