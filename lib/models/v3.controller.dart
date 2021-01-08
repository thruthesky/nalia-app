import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/v3.user.model.dart';
import 'package:nalia_app/services/config.dart';
import 'package:get_storage/get_storage.dart';

class V3 extends GetxController {
  @override
  void onInit() {
    super.onInit();
    GetStorage.init().then((b) {
      localStorage = GetStorage();
      final String sessionId = localStorage.read('session_id');
      userProfile(sessionId);
    });
  }

  Dio dio = Dio();
  final url = v3Url;
  GetStorage localStorage;

  User user;
  String get sessionId => user?.sessionId;
  String get primaryPhotoUrl => user?.primaryPhotoUrl;
  String get fullName => user?.fullName;
  String get dateMethod => user?.dateMethod;
  bool get profileComplete =>
      loggedIn &&
      primaryPhotoUrl != null &&
      primaryPhotoUrl.isNotEmpty &&
      fullName != null &&
      fullName.isNotEmpty;

  bool get loggedIn => user != null;
  bool get notLoggedIn => !loggedIn;

  Future<Map<String, dynamic>> request(Map<String, dynamic> data) async {
    if (loggedIn && data['sessionId'] == null) {
      data['session_id'] = user.sessionId;
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

  /// [data] will be saved as user property. You can save whatever but may need to update the User model accordingly.
  Future<User> register({
    @required String email,
    @required String pass,
    Map<String, dynamic> data,
  }) async {
    data['route'] = 'user.register';
    data['user_email'] = email;
    data['user_pass'] = pass;

    final Map<String, dynamic> res = await request(data);
    print('res: $res');
    user = User.fromJson(res);
    print('user: $user');

    await localStorage.write('session_id', user.sessionId);

    update();
    return user;
  }

  Future<User> loginOrRegister({
    @required String email,
    @required String pass,
    Map<String, dynamic> data,
  }) async {
    data['route'] = 'user.loginOrRegister';
    data['user_email'] = email;
    data['user_pass'] = pass;
    final Map<String, dynamic> res = await request(data);
    user = User.fromJson(res);
    await localStorage.write('session_id', user.sessionId);
    update();
    return user;
  }

  Future<User> login({
    @required String email,
    @required String pass,
  }) async {
    final Map<String, dynamic> data = {};
    data['route'] = 'user.login';
    data['user_email'] = email;
    data['user_pass'] = pass;
    final Map<String, dynamic> res = await request(data);
    user = User.fromJson(res);
    await localStorage.write('session_id', user.sessionId);
    update();
    return user;
  }

  updateToken(String token) {
    return request({'route': 'notification.updateToken', 'token': token});
  }

  updateUser(String key, String value) async {
    final Map<String, dynamic> data = {
      'route': 'user.profileUpdate',
      key: value,
    };
    final Map<String, dynamic> res = await request(data);
    user = User.fromJson(res);
    update();
  }

  userProfile(String sessionId) async {
    if (sessionId == null) return;
    final Map<String, dynamic> data =
        await request({'route': 'user.profile', 'session_id': sessionId});
    user = User.fromJson(data);
    update();
    return user;
  }
}
