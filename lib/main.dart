import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/screens/forum/forum.list.screen.dart';
import 'package:nalia_app/screens/home/home.screen.dart';
import 'package:nalia_app/screens/login/login.screen.dart';
import 'package:nalia_app/screens/profile/profile.screen.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';

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
      // Get.toNamed(RouteNames.forumList, arguments: {'category': 'reminder'});
    });

    app.firebaseReady.listen((ready) {
      print('Firebase ready: $ready');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
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
      ],
      // home: HomeScreen(),
    );
  }
}
