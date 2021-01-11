import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/screens/forum/forum.list.screen.dart';
import 'package:nalia_app/screens/home/home.screen.dart';
import 'package:nalia_app/screens/login/login.screen.dart';
import 'package:nalia_app/screens/profile/profile.screen.dart';
import 'package:nalia_app/screens/user_search/user_search.screen.dart';
import 'package:nalia_app/services/config.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/tests/user.test.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final API c = Get.put(api);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 600), () async {
      Get.toNamed(RouteNames.profile);
      // Get.toNamed(RouteNames.forumList, arguments: {'category': 'reminder'});

      () async {
        final ut = UserTest();
        try {
          File file = await ut.downloadImage(v3HomeUrl + '/tmp/img/1.jpg');
          print(file);
        } catch (e) {
          print('file error:');
          print(e);
        }
      }();
    });

    app.firebaseReady.listen((ready) {
      print('Firebase ready: $ready');
    });

    Dio dio = Dio();
    () async {
      final res = await dio
          .get('http://192.168.0.5/wordpress/v3/index.php?route=app.version');

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
        GetPage(name: RouteNames.userSearch, page: () => UserSearchScreen())
      ],
      // home: HomeScreen(),
    );
  }
}
