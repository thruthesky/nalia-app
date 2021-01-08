import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/services/config.dart';
import 'package:get_storage/get_storage.dart';

class User {
  String sessinoId;
  User({this.sessinoId});
}

class V3 extends GetxController {
  @override
  void onInit() {
    super.onInit();
    GetStorage.init().then((b) {
      localStorage = GetStorage();
    });
  }

  Dio dio = Dio();
  final url = v3Url;
  GetStorage localStorage;

  User user;

  bool get loggedIn => user != null;

  Future<Map<String, dynamic>> request(Map<String, dynamic> data) async {
    if (loggedIn) {
      data['session_id'] = user.sessinoId;
    }
    final res = await dio.get(url, queryParameters: data);
    if (res.data == null) {
      throw ('Response.body is null. Backend might not an API server. Or, Backend URL is wrong.');
    }
    if (res.data is String || res.data['code'] == null) {
      print('API ERROR RESPONSE:');
      print(res.data);
      throw (res.data);
    }
    if (res.data['code'] != 0) {
      throw res.data['code'];
    }
    return res.data['data'];
  }

  Future<Map<String, dynamic>> register({
    @required String email,
    @required String pass,
    Map<String, dynamic> extra,
  }) async {
    final req = {
      'route': 'user.register',
      'user_email': email,
      'user_pass': pass,
    };
    final Map<String, dynamic> data = await request(req);
    print(jsonEncode(data));
    localStorage.write('session_id', data['session_id']);
    user = User(sessinoId: data['session_id']);
    print(user.sessinoId);
    update();
    return data;
  }

  updateToken(String token) {
    return request({'route': 'notification.updateToken', 'token': token});
  }
}
