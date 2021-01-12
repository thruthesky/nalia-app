import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.bio.controller.dart';
import 'package:nalia_app/models/api.bio.model.dart';
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
  // ApiBio bio;
  @override
  void initState() {
    super.initState();

    // app.getBio().then((bio) => setState(() => this.bio = bio));
  }

  @override
  Widget build(BuildContext context) {
    // print('_ProfileScreenState::build()');
    // print(bio);
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: api.notLoggedIn
            ? LoginFirst()
            : SingleChildScrollView(
                child: GetBuilder<Bio>(
                  builder: (model) {
                    if (model.ready == false) return SizedBox.shrink();
                    ApiBio bio = Bio.data;
                    return Container(
                      padding: EdgeInsets.only(left: md, right: md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text('사진 등록'),
                              onPressed: () => app.open(RouteNames.gallery),
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
                              '이름: ${api.fullName}\n전화: ${api.user.phoneNo}\n생일: ${bio.birthdate}\n성별: ${bio.gender.tr} '),
                          spaceXs,
                          Divider(),
                          spaceXs,
                          Column(
                            children: [
                              DateMethod(),
                              Height(),
                              Weight(),
                              City(),
                              Hobby(),
                              Drinking(),
                              Smoking(),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class DateMethod extends StatefulWidget {
  @override
  _DateMethodState createState() => _DateMethodState();
}

class _DateMethodState extends State<DateMethod> {
  PublishSubject dateMethod = PublishSubject();
  StreamSubscription dateMethodSub;
  @override
  void initState() {
    super.initState();

    dateMethodSub = dateMethod.debounceTime(Duration(milliseconds: 500)).distinct().listen((v) {
      Get.find<Bio>().updateBio('dateMethod', v);
    });
  }

  @override
  void dispose() {
    super.dispose();
    dateMethodSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('date method hint'.tr, style: hintStyle),
        Text('date method example'.tr, style: hintStyle),
        spaceXs,
        GetBuilder<Bio>(
          builder: (_) {
            return TextFormField(
              initialValue: Bio.data?.dateMethod ?? '',
              onChanged: (v) => dateMethod.add(v),
            );
          },
        ),
        spaceMd,
        Text('input bio data'.tr, style: hintStyle),
      ],
    ));
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
          GetBuilder<Bio>(
            builder: (_) {
              return DropdownButton<String>(
                value: Bio.data?.height ?? '',
                onChanged: (v) async {
                  try {
                    await _.updateBio('height', v);
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
              );
            },
          )
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
          GetBuilder<Bio>(
            builder: (_) {
              return DropdownButton<String>(
                value: Bio.data?.weight ?? '',
                onChanged: (v) async {
                  try {
                    await _.updateBio('weight', v);
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
              );
            },
          )
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
          GetBuilder<Bio>(
            builder: (_) {
              return DropdownButton<String>(
                value: Bio.data?.city ?? '',
                onChanged: (v) async {
                  try {
                    await _.updateBio('city', v);
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
              );
            },
          )
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
          GetBuilder<Bio>(
            builder: (_) {
              return DropdownButton<String>(
                value: Bio.data?.hobby ?? '',
                onChanged: (v) async {
                  try {
                    await _.updateBio('hobby', v);
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
              );
            },
          )
        ],
      ),
    );
  }
}

class Drinking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('drink'.tr, style: hintStyle),
          GetBuilder<Bio>(
            builder: (_) {
              return SwitchListTile(
                title: Text('drinking_yn'.tr),
                value: Bio.data?.drinking == 'Y' ? true : false,
                onChanged: (bool value) async {
                  try {
                    await _.updateBio('drinking', value ? 'Y' : 'N');
                  } catch (e) {
                    app.error(e);
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class Smoking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceMd,
          Text('smoke'.tr, style: hintStyle),
          GetBuilder<Bio>(
            builder: (_) {
              return SwitchListTile(
                title: Text('smoking_yn'.tr),
                value: Bio.data?.smoking == 'Y' ? true : false,
                onChanged: (bool value) async {
                  try {
                    await _.updateBio('smoking', value ? 'Y' : 'N');
                  } catch (e) {
                    app.error(e);
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
