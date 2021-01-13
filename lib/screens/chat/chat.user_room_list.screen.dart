import 'dart:async';

import 'package:firechat/firechat.dart';
import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/helper.functions.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/login_first.dart';
import 'package:nalia_app/widgets/spinner.dart';
import 'package:nalia_app/widgets/user_avatar.dart';

class ChatUserRoomListScreen extends StatefulWidget {
  @override
  _ChatUserRoomListScreenState createState() => _ChatUserRoomListScreenState();
}

class _ChatUserRoomListScreenState extends State<ChatUserRoomListScreen> {
  StreamSubscription subscription;

  /// [_otherUsername] is a cache container for speed and prevening flashing.
  Map<String, Widget> _otherUsername = {};
  otherUsername(ChatUserRoom privateRoom) {
    // if the room has its own title, then use it.
    if (privateRoom.global == null) return SizedBox.shrink();
    if (privateRoom.global.title != null &&
        privateRoom.global.title.trim() != '') {
      return Text(privateRoom.global.title);
    }

    // get the other user uid
    String uid = privateRoom.global.otherUserId;
    if (uid == null) return SizedBox.shrink();

    // if the user name has already cached, just return the cached widget of it.
    if (_otherUsername[uid] != null) return _otherUsername[uid];

    return FutureBuilder<ApiBio>(
      future: app.getBio(uid),
      builder: (_, snapshot) {
        if (snapshot.hasError) return SizedBox.shrink();
        if (snapshot.connectionState == ConnectionState.waiting)
          return Spinner();
        _otherUsername[uid] = Text(
          snapshot.data.name,
          style: TextStyle(fontSize: md),
        );
        return _otherUsername[uid];
      },
    );
  }

  /// Cache for speed and prevening flashing
  ///
  Map<String, Widget> _otherUserAvatar = {};
  otherUserAvatar(ChatUserRoom privateRoom) {
    if (privateRoom.global == null) return SizedBox.shrink();

    // get the other user uid
    String uid = privateRoom.global.otherUserId;
    if (uid == null) return SizedBox.shrink();

    if (_otherUserAvatar[uid] != null) return _otherUserAvatar[uid];

    return SizedBox(
      width: 48,
      height: 48,
      child: FutureBuilder<ApiBio>(
        future: app.getBio(uid),
        builder: (_, snapshot) {
          if (snapshot.hasError) return SizedBox.shrink();
          if (snapshot.connectionState == ConnectionState.waiting)
            return Spinner();
          _otherUserAvatar[uid] = UserAvatar(snapshot.data.profilePhotoUrl);
          return _otherUserAvatar[uid];
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    subscription = myRoomListChanges.listen((rooms) => setState(() {
          // print('rooms:');
          // print(rooms);
          // print("myRoomList?.fetched: ${myRoomList?.fetched}");
        }));
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('내 친구 목록'), Text('챈구 찾기')],
        ),
        child: Container(
          child: api.notLoggedIn
              ? LoginFirst()
              : myRoomList?.fetched != true
                  ? Spinner()
                  : ListView.builder(
                      itemCount: myRoomList.rooms.length,
                      itemBuilder: (_, i) {
                        ChatUserRoom room = myRoomList.rooms[i];
                        return ListTile(
                          leading: otherUserAvatar(room),
                          title: otherUsername(room),
                          subtitle: Text(room.text),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(shortDateTime(room.createdAt),
                                  style: hintStyle),
                              Spacer(),
                              if (room.newMessages > 0)
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: md),
                                  child: Chip(
                                    labelPadding:
                                        EdgeInsets.fromLTRB(4, -4, 4, -4),
                                    label: Text(
                                      '${room.newMessages}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              Spacer(),
                            ],
                          ),
                          onTap: () => app.openChatRoom(roomId: room.id),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
