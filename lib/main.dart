import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firechat/firechat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nalia_app/models/api.bio.controller.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/models/api.gallery.controller.dart';
import 'package:nalia_app/screens/chat/chat.room.screen.dart';
import 'package:nalia_app/screens/chat/chat.user_room_list.screen.dart';
import 'package:nalia_app/screens/forum/forum.list.screen.dart';
import 'package:nalia_app/screens/gallery/gallery.screen.dart';
import 'package:nalia_app/screens/home/home.screen.dart';
import 'package:nalia_app/screens/login/login.screen.dart';
import 'package:nalia_app/screens/menu/menu.screen.dart';
import 'package:nalia_app/screens/profile/profile.screen.dart';
import 'package:nalia_app/screens/purchase/purchase.screen.dart';
import 'package:nalia_app/screens/user_search/user_search.screen.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';

void main() {
  // Let the plugin know that this app supports pending purchases.
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final API c = Get.put(api);
  final Gallery g = Get.put(Gallery());
  final Bio b = Get.put(Bio());
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 600), () async {
      // app.open(RouteNames.userSearch);
      // app.open(RouteNames.gallery);
      // app.open(RouteNames.profile);
      // app.open(RouteNames.forumList, arguments: {'category': 'reminder'});
    });

    app.firebaseReady.listen((ready) async {
      // print('Firebase ready: $ready');
      if (ready == false) return;
      // todo: purchase produces error on iOS.
      if (Platform.isIOS) return;
      purchase.init(
        productIds: {
          'lucky_box',
          'jewelry_box',
          'diamond_box',
        },
      );
      print('products: ${purchase.products} : Simulator does not show products.');
    });

    // Dio dio = Dio();
    // () async {
    //   final res = await dio
    //       // .get('http://192.168.0.5/wordpress/v3/index.php?route=app.version');
    //       .get(
    //           'http://192.168.100.17/wordpress55/v3/index.php?route=app.version');

    //   print('res: ${res.data}');
    // }();

    app.firebaseReady.listen((ready) {
      if (ready == false) return;
      api.authChanges.listen((user) {
        if (user == null) return;

        print('main.dart -> firebaseReady -> authChanges ->user: $user');
        // Listening login user's chat room changes.
        // This must be here to listen new messages outside from chat screens.
        // Reset room list, when user just logs in/out.
        if (myRoomList == null) {
          myRoomList = ChatMyRoomList(
            loginUserId: api.id,
            render: () {
              // When there are changes(events) on my chat room list,
              // notify to listeners.
              myRoomListChanges.add(myRoomList.rooms);
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.noTransition,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: RouteNames.home,
      getPages: [
        GetPage(name: RouteNames.home, page: () => HomeScreen()),
        GetPage(name: RouteNames.login, page: () => LoginScreen()),
        GetPage(name: RouteNames.profile, page: () => ProfileScreen()),
        GetPage(name: RouteNames.forumList, page: () => ForumListScreen()),
        GetPage(name: RouteNames.userSearch, page: () => UserSearchScreen()),
        GetPage(name: RouteNames.gallery, page: () => GalleryScreen()),
        GetPage(name: RouteNames.purchase, page: () => PurchaseScreen()),
        GetPage(name: RouteNames.menu, page: () => MenuScreen()),
        GetPage(name: RouteNames.chatRoom, page: () => ChatRoomScreen()),
        GetPage(name: RouteNames.chatRoomList, page: () => ChatUserRoomListScreen())
      ],
    );
  }
}
