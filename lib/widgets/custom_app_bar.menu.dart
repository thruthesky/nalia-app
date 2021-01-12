import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:icon_animator/icon_animator.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/models/api.gallery.controller.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/user_avatar.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:badges/badges.dart';

class CustomAppBarMenu extends StatefulWidget {
  CustomAppBarMenu({@required this.route});
  final String route;
  @override
  _CustomAppBarMenuState createState() => _CustomAppBarMenuState();
}

class _CustomAppBarMenuState extends State<CustomAppBarMenu> {
  StreamSubscription subscription;
  int count = 0;
  @override
  void initState() {
    super.initState();
    subscription = myRoomListChanges.listen((rooms) {
      count = 0;
      if (rooms != null && rooms.length > 0) {
        for (final room in rooms) {
          // Skip counting
          if (chat != null && chat.id == room.id) {
            continue;
          }
          if (room.newMessages != null) {
            count += room.newMessages;
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.route == RouteNames.home ? Colors.white : kPrimaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          // padding: EdgeInsets.only(top: 4, bottom: 4),
          // height: HEADER_HEIGHT,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(FontAwesome5Solid.users, color: color),
                onPressed: () => app.open(RouteNames.home),
                splashRadius: 28.4,
              ),
              IconButton(
                icon: Obx(() {
                  if (app.justGotDailyBonus.value) {
                    return IconAnimator(
                      finish: Icon(FontAwesome5Solid.heartbeat, color: color),
                      children: [
                        AnimationFrame(icon: FontAwesome5Solid.heartbeat, color: Colors.red, size: 28, duration: 500),
                        AnimationFrame(icon: FontAwesome5Solid.heartbeat, color: color, duration: 500),
                      ],
                    );
                  }

                  return Icon(FontAwesome5Solid.heartbeat, color: color);
                }),
                onPressed: () => app.open(RouteNames.myJewelry),
                splashRadius: 28.4,
              ),
              GestureDetector(
                onTap: () => app.open(RouteNames.chatRoomList),
                behavior: HitTestBehavior.opaque,
                child: Badge(
                  showBadge: count > 0,
                  toAnimate: false,
                  badgeContent: Text(
                    '$count',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  child: Icon(FontAwesome5Solid.comments, color: color),
                ),
              ),

              // IconButton(
              //   icon: Icon(FontAwesome5Solid.comments, color: color),
              //   onPressed: () => app.open(RouteNames.chatRoomList),
              //   splashRadius: 28.4,
              // ),

              GetBuilder<Gallery>(
                builder: (_) {
                  return UserAvatar(
                    _.featuredImageUrl,
                    size: HEADER_HEIGHT - 10.0,
                    onTap: () => app.open(RouteNames.profile),
                  );
                },
              ),

              // StreamBuilder(
              //   stream: api.userChanges,
              //   builder: (_, snapshot) {
              //     return UserAvatar(
              //       ff.userPublicData[PRIMARY_PHOTO],
              //       size: HEADER_HEIGHT - 10.0,
              //       onTap: () => app.open(RouteNames.profile),
              //     );
              //   },
              // ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(FontAwesome5Solid.bars, color: color),
                    onPressed: () => app.open(RouteNames.menu),
                    splashRadius: 28.4,
                  ),
                  AppIndicator(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

/// first bullet is for location
/// second bullet is for push notification permission
/// third bullet is for other permissions like profile is ready.
class AppIndicator extends StatefulWidget {
  AppIndicator({
    Key key,
  }) : super(key: key);

  @override
  _AppIndicatorState createState() => _AppIndicatorState();
}

class _AppIndicatorState extends State<AppIndicator> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              if (app.locationReady) {
                return NoneIndicator();
              } else {
                return ErrorIndicator();
              }
            }),
            spaceXxs,
            GreenIndicator(),
            spaceXxs,
            EtcIndicator(),
          ],
        ),
        onTap: () => app.open(RouteNames.menu),
      ),
    );
  }
}

class EtcIndicator extends StatefulWidget {
  const EtcIndicator({
    Key key,
  }) : super(key: key);

  @override
  _EtcIndicatorState createState() => _EtcIndicatorState();
}

class _EtcIndicatorState extends State<EtcIndicator> {
  // Widget child;
  // @override
  // void initState() {
  //   child = NoneIndicator();
  //   super.initState();
  //   ff.userPublicDataChange.listen((data) {
  //     if (ff.loggedIn) {
  //       if (app.profileComplete) {
  //         child = GreenIndicator();
  //       } else {
  //         child = WarningIndicator();
  //       }
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<API>(
      builder: (_) {
        return _.profileComplete ? GreenIndicator() : WarningIndicator();
      },
    );
  }
}

class NoneIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Color(0x88FFFFFF),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}

class WarningIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}

class GreenIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}

class ErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconAnimator(
      children: [
        AnimationFrame(
          duration: 1000,
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        AnimationFrame(
          duration: 1000,
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        )
      ],
    );
  }
}
