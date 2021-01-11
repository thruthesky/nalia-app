import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/models/api.gallery.controller.dart';
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
  final Gallery b = Get.put(Gallery());
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 600), () async {
      // Get.toNamed(RouteNames.userSearch);
      // Get.toNamed(RouteNames.gallery);
      // Get.toNamed(RouteNames.profile);
      // Get.toNamed(RouteNames.forumList, arguments: {'category': 'reminder'});
    });

    app.firebaseReady.listen((ready) async {
      print('Firebase ready: $ready');
      if (ready == false) return;
      purchase.init(
        productIds: {
          'lucky_box',
          'jewelry_box',
          'diamond_box',
        },
      );
      print('products: ${purchase.products} : Simulator does not show products.');
    });

    Dio dio = Dio();
    () async {
      final res = await dio
          // .get('http://192.168.0.5/wordpress/v3/index.php?route=app.version');
          .get('http://192.168.100.17/wordpress55/v3/index.php?route=app.version');

      print('res: ${res.data}');
    }();
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
        GetPage(name: RouteNames.menu, page: () => MenuScreen())
      ],
    );
  }
}
