import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as Prefix;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/models/api.user.model.dart';
import 'package:nalia_app/services/config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nalia_app/services/helper.functions.dart';

class Forum {
  String category;
  List<ApiPost> posts = [];
  bool loading = false;
  bool noMorePosts = false;
  int pageNo = 0;
  bool get canLoad => loading == false && noMorePosts == false;
  ScrollController listController = ScrollController();
  Function render;

  ApiPost postInEdit;
  Forum({@required this.category, @required this.render});

  /// Edit post or comment
  ///
  /// To create a post
  /// ```
  /// edit(post: ApiPost())
  /// ```
  ///
  /// To update a post
  /// ```
  /// edit(post: post);
  /// ```
  ///
  /// To cancel editing post
  /// ```
  /// edit(null)
  /// ```
  editPost(ApiPost post) {
    postInEdit = post;
    render();
  }

  /// Inserts a new post on top or updates an existing post.
  insertOrUpdate(post) {
    postInEdit = null;
    posts.insert(0, post);
    render();
    WidgetsBinding.instance.addPostFrameCallback((x) {
      listController.jumpTo(1);
    });
    // Timer(Duration(milliseconds: 100), () {
    //   listController.animateTo(1,
    //       duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    // });
  }
}

class API extends GetxController {
  @override
  void onInit() {
    super.onInit();
    GetStorage.init().then((b) {
      localStorage = GetStorage();

      /// Load user profile from localStorage.
      /// If the user has logged in previously, he will be auto logged in on next app running.
      user = _loadUserProfile();
      if (loggedIn)
        print('ApiUser logged in with cached profile: ${user.sessionId}');

      /// If user has logged in with localStorage data, refresh the user data from backend.
      if (loggedIn) {
        userProfile(sessionId);
      }
    });
  }

  Prefix.Dio dio = Prefix.Dio();
  final url = v3Url;
  GetStorage localStorage;

  ApiUser user;
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

  bool get loggedIn => user != null && user.sessionId != null;
  bool get notLoggedIn => !loggedIn;

  /// If the input [data] does not have `session_id` property, add it.
  Map<String, dynamic> _addSessionId(Map<String, dynamic> data) {
    if (data['session_id'] != null) return data;
    if (notLoggedIn) return data;

    data['session_id'] = user.sessionId;

    return data;
  }

  Future<dynamic> request(Map<String, dynamic> data) async {
    data = _addSessionId(data);
    final res = await dio.get(url, queryParameters: data);
    if (res.data == null) {
      throw ('Response.body is null. Backend might not an API server. Or, Backend URL is wrong.');
    }

    if (res.data is String || res.data['code'] == null) {
      throw (res.data);
    } else if (res.data['code'] != 0) {
      throw res.data['code'];
    }
    return res.data['data'];
  }

  /// [data] will be saved as user property. You can save whatever but may need to update the ApiUser model accordingly.
  Future<ApiUser> register({
    @required String email,
    @required String pass,
    Map<String, dynamic> data,
  }) async {
    data['route'] = 'user.register';
    data['user_email'] = email;
    data['user_pass'] = pass;

    final Map<String, dynamic> res = await request(data);
    print('res: $res');
    user = ApiUser.fromJson(res);
    print('user: $user');

    await _saveUserProfile(user);

    update();
    return user;
  }

  Future<ApiUser> loginOrRegister({
    @required String email,
    @required String pass,
    Map<String, dynamic> data,
  }) async {
    data['route'] = 'user.loginOrRegister';
    data['user_email'] = email;
    data['user_pass'] = pass;
    final Map<String, dynamic> res = await request(data);
    user = ApiUser.fromJson(res);
    await _saveUserProfile(user);
    update();
    return user;
  }

  _saveUserProfile(ApiUser user) async {
    await localStorage.write('user', user.toJson());
  }

  ApiUser _loadUserProfile() {
    final json = localStorage.read('user');
    return ApiUser.fromJson(json);
  }

  Future<ApiUser> login({
    @required String email,
    @required String pass,
  }) async {
    final Map<String, dynamic> data = {};
    data['route'] = 'user.login';
    data['user_email'] = email;
    data['user_pass'] = pass;
    final Map<String, dynamic> res = await request(data);
    user = ApiUser.fromJson(res);
    await _saveUserProfile(user);
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
    user = ApiUser.fromJson(res);
    update();
  }

  userProfile(String sessionId) async {
    if (sessionId == null) return;
    final Map<String, dynamic> data =
        await request({'route': 'user.profile', 'session_id': sessionId});
    user = ApiUser.fromJson(data);
    update();
    return user;
  }

  Future<ApiPost> editPost({
    String category,
    String title,
    String content,
    List<ApiFile> files,
    Map<String, dynamic> data,
  }) async {
    if (data == null) data = {};
    data['route'] = 'forum.editPost';
    data['category'] = category;
    data['post_title'] = title;
    data['post_content'] = content;
    if (files != null) {
      Set ids = files.map((file) => file.id).toSet();
      data['files'] = ids.join(',');
    }
    final json = await request(data);
    return ApiPost.fromJson(json);
  }

  Future<ApiPost> getPost(dynamic id) async {
    final json = await request({'route': 'forum.getPost', 'id': id});
    return ApiPost.fromJson(json);
  }

  Future<List<ApiPost>> searchPost({String category}) async {
    final Map<String, dynamic> data = {};
    data['route'] = 'forum.search';
    data['category_name'] = category;
    final jsonList = await request(data);

    List<ApiPost> _posts = [];
    for (int i = 0; i < jsonList.length; i++) {
      _posts.add(ApiPost.fromJson(jsonList[i]));
    }
    return _posts;
  }

  Future<ApiFile> uploadFile({@required File file, Function onProgress}) async {
    /// [Prefix] 를 쓰는 이유는 Dio 의 FromData 와 Flutter 의 기본 HTTP 와 충돌하기 때문이다.
    final formData = Prefix.FormData.fromMap({
      /// `route` 와 `session_id` 등 추가 파라메타 값을 전달 할 수 있다.
      'route': 'file.upload',
      'session_id': sessionId,

      /// 아래에서 `userfile` 이, `$_FILES[userfile]` 와 같이 들어간다.
      'userfile': await Prefix.MultipartFile.fromFile(
        file.path,

        /// `filename` 은 `$_FILES[userfile][name]` 와 같이 들어간다.
        filename: getFilenameFromPath(file.path),
      ),
    });

    final res = await dio.post(
      url,
      data: formData,
      onSendProgress: (int sent, int total) {
        if (onProgress != null) onProgress((sent * 100 / total).round());
      },
    );
    if (res.data is String || res.data['code'] == null) {
      throw (res.data);
    } else if (res.data['code'] != 0) {
      throw res.data['code'];
    }
    return ApiFile.fromJson(res.data['data']);
  }

  /// Deletes a file.
  ///
  /// id] is the file id to delete.
  /// [post] is the post that this file is attached to.
  ///
  /// It returns deleted file id.
  Future<int> deleteFile(int id, {ApiPost post}) async {
    final dynamic data = await request({
      'route': 'file.delete',
      'ID': id,
    });
    int i = post.files.indexWhere((file) => file.id == id);
    post.files.removeAt(i);
    return data['ID'];
  }

  /// Forum List Management
  Map<String, Forum> forumContainer = {};

  Forum resetForum({@required String category, @required Function render}) {
    forumContainer[category] = Forum(category: category, render: render);
    return forumContainer[category];
  }

  fetchPosts({Forum forum, String category}) async {
    if (category != null) forum = forumContainer[category];
    if (forum.canLoad == false) return;
    forum.loading = true;
    forum.render();

    List<ApiPost> _posts;
    _posts = await searchPost(category: forum.category);

    if (_posts.length == 0) {
      forum.noMorePosts = true;
      forum.render();
      return;
    }

    _posts.forEach((ApiPost p) {
      forum.posts.add(p);
    });

    forum.loading = false;
    forum.render();
  }

  /// EO
}
