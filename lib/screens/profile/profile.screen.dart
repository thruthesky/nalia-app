import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/services/debouncer.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:get/get.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/login_first.dart';
import 'package:rxdart/rxdart.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PublishSubject dateMethod = PublishSubject();
  StreamSubscription dateMethodSub;
  @override
  void initState() {
    super.initState();
    dateMethodSub = dateMethod
        .debounceTime(Duration(milliseconds: 500))
        .distinct()
        .listen((v) {
      print('v: $v');
      api.updateUser('dateMethod', v);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateMethodSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // print('_ProfileScreenState::build()');
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: GetBuilder<API>(builder: (_) {
          if (_.notLoggedIn) return LoginFirst();
          return HomeContentWrapper(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: md, right: md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text('사진 등록'),
                        onPressed: () => Get.toNamed(RouteNames.gallery),
                        // app.homeStackChange(HomeStack.gallery),
                      ),
                    ),
                    Text('회원 프로필', style: titleStyle),
                    spaceXs,
                    Text(
                      '본인 인증에 의해 이름, 전화번호, 생년월일, 성별은 자동으로 기록됩니다.',
                      style: hintStyle,
                    ),
                    spaceXs,
                    Text(
                        '이름: ${_.fullName}\n전화: ${_.user.phoneNo}\n생일: ${_.user.birthdate}\n성별: ${_.user.gender.tr} '),
                    spaceXs,
                    Divider(),
                    spaceXs,
                    Text('date method hint'.tr, style: hintStyle),
                    Text('date method example'.tr, style: hintStyle),
                    spaceXs,
                    TextFormField(
                      initialValue: _.dateMethod,
                      onChanged: (v) => dateMethod.add(v),
                    ),
                    spaceMd,
                    Text('input bio data'.tr, style: hintStyle),
                    spaceXs,
                    Column(
                      children: [
                        Height(),
                        Weight(),
                        City(),
                        Hobby(),
                        Drink(),
                        Smoke(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class Height extends StatelessWidget {
  final debounce = Debouncer(delay: Duration(milliseconds: 600));
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('height'.tr, style: hintStyle),
          DropdownButton<String>(
            value: api.user.height,
            onChanged: (v) async {
              try {
                await api.updateUser('height', v);
              } catch (e) {
                app.error(e);
              }
            },
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(
                  'choose'.tr,
                  style: TextStyle(fontSize: md),
                ),
              ),
              for (int _h = 140; _h < 200; _h++)
                DropdownMenuItem(
                  value: _h.toString(),
                  child: Text(
                    '$_h cm',
                    style: TextStyle(fontSize: md),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Weight extends StatelessWidget {
  final debounce = Debouncer(delay: Duration(milliseconds: 600));
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('weight'.tr, style: hintStyle),
          DropdownButton<String>(
            value: api.user.weight,
            onChanged: (v) async {
              try {
                await api.updateUser('weight', v);
              } catch (e) {
                app.error(e);
              }
            },
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(
                  'choose'.tr,
                  style: TextStyle(fontSize: md),
                ),
              ),
              for (int _w = 45; _w <= 120; _w++)
                DropdownMenuItem(
                  value: _w.toString(),
                  child: Text(
                    '$_w kg',
                    style: TextStyle(fontSize: md),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class City extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('city'.tr, style: hintStyle),
          DropdownButton<String>(
            value: api.user.city ?? '',
            onChanged: (v) async {
              try {
                await api.updateUser('city', v);
              } catch (e) {
                app.error(e);
              }
            },
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(
                  'choose'.tr,
                  style: TextStyle(fontSize: md),
                ),
              ),
              for (String _city in Cities)
                DropdownMenuItem(
                  value: _city,
                  child: Text(
                    _city,
                    style: TextStyle(fontSize: md),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Hobby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('hobby'.tr, style: hintStyle),
          DropdownButton<String>(
            value: api.user.hobby,
            onChanged: (v) async {
              try {
                await api.updateUser('hobby', v);
              } catch (e) {
                app.error(e);
              }
            },
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(
                  'choose'.tr,
                  style: TextStyle(fontSize: md),
                ),
              ),
              for (String _hobby in Hobbies)
                DropdownMenuItem(
                  value: _hobby,
                  child: Text(
                    _hobby,
                    style: TextStyle(fontSize: md),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Drink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('drink'.tr, style: hintStyle),
          SwitchListTile(
            title: Text('drinking_yn'.tr),
            value: api.user.drinking == 'Y' ? true : false,
            onChanged: (bool value) async {
              try {
                await api.updateUser('drinking', value ? 'Y' : 'N');
              } catch (e) {
                app.error(e);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Smoke extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('smoke'.tr, style: hintStyle),
          SwitchListTile(
            title: Text('smoking_yn'.tr),
            value: api.user.smoking == 'Y' ? true : false,
            onChanged: (bool value) async {
              try {
                await api.updateUser('smoking', value ? 'Y' : 'N');
              } catch (e) {
                app.error(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
