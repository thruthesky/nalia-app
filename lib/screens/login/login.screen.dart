import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/api.user.model.dart';
import 'package:nalia_app/services/config.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/spinner.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceMd,
            Container(
              padding: EdgeInsets.only(left: md, right: md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '성인인증',
                    style: titleStyle,
                  ),
                  spaceXs,
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: '나리야 앱은 '),
                        TextSpan(
                            text: '성인인증',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '을 통해서 '),
                        TextSpan(
                          text: '20세 이상 성인이 실명',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        // TextSpan(text: ' 성인이'),
                        // TextSpan(text: '실명'),
                        TextSpan(text: '으로만 이용 할 수 있습니다.')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            spaceMd,
            loggedIn
                ? Spinner()
                : Expanded(
                    child: WebView(
                      initialUrl: passCallbackUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      javascriptChannels: Set.from([
                        JavascriptChannel(
                            name: 'messageHandler',
                            onMessageReceived: (JavascriptMessage jm) async {
                              api.user =
                                  ApiUser.fromJson(jsonDecode(jm.message));
                              print("Pass login api.user: ${api.user}");
                              int agegroup = int.parse(api.user.agegroup);
                              if (agegroup == 0 || agegroup == 10) {
                                app.alert('미성년자는 가입 할 수 없습니다.');
                                return;
                              }

                              setState(() {
                                loggedIn = true;
                              });

                              // await app.firebaseLoginOrRegister(user);

                              Get.toNamed(RouteNames.profile);
                            })
                      ]),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
