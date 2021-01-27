import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/config.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/tests/post.test.dart';
import 'package:nalia_app/tests/user.test.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:withcenter/withcenter.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool loggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.jewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('app-name'.tr),
              Text('address'.tr),
              GetBuilder<WithcenterApi>(
                builder: (_) {
                  return Text(
                    'session_id: ${_.user?.sessionId}, name: ${_.user?.name}, ${_.user?.gender}, ${_.user?.birthdate}, ${_.user?.age} ',
                  );
                },
              ),
              Text('endpoint: $apiUrl'),
              Wrap(
                children: [
                  RaisedButton(
                    onPressed: () => app.open(RouteNames.login),
                    child: Text('Login'),
                  ),
                  RaisedButton(
                    onPressed: () => withcenterApi.logout(),
                    child: Text('Logout'),
                  ),
                  RaisedButton(
                    onPressed: () => app.open(RouteNames.profile),
                    child: Text('Profile'),
                  ),
                  RaisedButton(
                    onPressed: () => app.open(RouteNames.gallery),
                    child: Text('Gallery'),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        final int no = Random().nextInt(10000);
                        final re = await withcenterApi.register(
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
                  RaisedButton(
                    child: Text('Reminder'),
                    onPressed: () => app.open(RouteNames.forumList, arguments: {
                      'category': 'reminder',
                    }),
                  ),
                  RaisedButton(
                    child: Text('QnA'),
                    onPressed: () => app.open(RouteNames.forumList, arguments: {
                      'category': 'qna',
                    }),
                  ),
                  RaisedButton(
                    child: Text('Discussion'),
                    onPressed: () => app.open(RouteNames.forumList, arguments: {
                      'category': 'discussion',
                    }),
                  ),
                  RaisedButton(
                    child: Text('Post creation test'),
                    onPressed: () async {
                      try {
                        final post = await PostTest().run();
                        print('post created: id: ${post.id}, no of images: ${post.files.length}');
                        print(post.files[0].url);
                      } catch (e) {
                        app.error(e);
                        if (e == ERROR_IMAGE_NOT_SELECTED) {
                        } else {
                          print('e: $e');
                        }
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('User search'),
                    onPressed: () => app.open(RouteNames.userSearch),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: UserTest().generate,
                child: Text('Generate 40 Users'),
              ),
              RaisedButton(
                child: Text('Purchase'),
                onPressed: () => app.open(RouteNames.purchase),
              ),
              RaisedButton(
                child: Text('Purchase History'),
                onPressed: () => app.open(RouteNames.purchaseHistory),
              ),
              Divider(),
              Text('Login test users'),
              Wrap(
                children: [
                  for (int i = 0; i < 40; i++)
                    RaisedButton(
                      onPressed: () async {
                        final tu = UserTest().data(i);
                        try {
                          final u = await withcenterApi.login(email: tu['user_email'], pass: tu['user_pass']);
                          print('Login success: $u');
                        } catch (e) {
                          app.error(e);
                        }
                      },
                      child: Text(
                        "$i" + UserTest().data(i)['gender'],
                      ),
                    ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    final int no = Random().nextInt(10000);
                    final re = await withcenterApi.updateToken('token:$no');
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
      ),
    );
  }
}
