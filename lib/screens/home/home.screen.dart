import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/v3.controller.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:faker/faker.dart';
import 'package:nalia_app/tests/test.user.dart';

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
          children: <Widget>[
            GetBuilder<V3>(
              builder: (_) {
                return Text(
                  'session_id: ${_.user?.sessionId}, name: ${_.user?.name}, ${_.user?.gender}, ${_.user?.birthdate}, ${_.user?.age} ',
                );
              },
            ),
            Wrap(
              children: [
                RaisedButton(
                  onPressed: () => Get.toNamed(RouteNames.login),
                  child: Text('Login'),
                ),
                RaisedButton(
                  onPressed: () => Get.toNamed(RouteNames.profile),
                  child: Text('Profile'),
                ),
                RaisedButton(
                  onPressed: () async {
                    try {
                      final int no = Random().nextInt(10000);
                      final re = await v3.register(
                        email: 'abc$no@test.com',
                        pass: 'abc@test.com',
                        data: {
                          'name': Faker().person.name(),
                          'a': 'Apple',
                        },
                      );
                      print(re);
                    } catch (e) {
                      app.error(e);
                    }
                  },
                  child: Text('Create an Account'),
                ),
              ],
            ),
            RaisedButton(
              onPressed: () async {
                try {
                  for (int i = 0; i < 40; i++) {
                    final temp = TestUser().data(i);
                    final re = await v3.loginOrRegister(
                        email: temp['user_email'],
                        pass: temp['user_pass'],
                        data: temp);
                    print('re: $re');
                  }
                } catch (e) {
                  app.error(e);
                }
              },
              child: Text('Generate 40 Users'),
            ),
            Divider(),
            Text('Login test users'),
            Wrap(
              children: [
                for (int i = 0; i < 40; i++)
                  RaisedButton(
                    onPressed: () async {
                      final tu = TestUser().data(i);
                      try {
                        final u = await v3.login(
                            email: tu['user_email'], pass: tu['user_pass']);
                        print('Login success: $u');
                      } catch (e) {
                        app.error(e);
                      }
                    },
                    child: Text(
                      "$i" + TestUser().data(i)['gender'],
                    ),
                  ),
              ],
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
