import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/v3.controller.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GetBuilder<V3>(
              builder: (_) {
                return Text(
                  'session_id: ${_.user?.sessinoId} ',
                );
              },
            ),
            RaisedButton(
              onPressed: () => Get.toNamed(RouteNames.login),
              child: Text('Login'),
            ),
            RaisedButton(
              onPressed: () => Get.toNamed(RouteNames.register),
              child: Text('Register'),
            ),
            RaisedButton(
              onPressed: () async {
                try {
                  final int no = Random().nextInt(10000);
                  final re = await v3.register(
                    email: 'abc$no@test.com',
                    pass: 'abc@test.com',
                    extra: {},
                  );
                  print(re);
                } catch (e) {
                  app.error(e);
                }
              },
              child: Text('Create an Account'),
            ),
            RaisedButton(
              onPressed: () async {
                try {
                  final int no = Random().nextInt(10000);
                  final re = await v3.updateToken('token:$no');
                  print(re);
                } catch (e) {
                  app.error(e);
                }
              },
              child: Text('Save token ID'),
            )
          ],
        ),
      ),
    );
  }
}
