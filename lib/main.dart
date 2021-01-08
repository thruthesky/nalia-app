import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/v3.controller.dart';
import 'package:nalia_app/screens/home/home.screen.dart';
import 'package:nalia_app/screens/login/login.screen.dart';
import 'package:nalia_app/screens/register/register.screen.dart';
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
  final V3 c = Get.put(v3);
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
        GetPage(name: RouteNames.register, page: () => RegisterScreen()),
      ],
      // home: HomeScreen(),
    );
  }
}
