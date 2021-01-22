import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firechat/firechat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nalia_app/controllers/api.bio.controller.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/controllers/api.nalia.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/services/config.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/helper.functions.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:nalia_app/services/push_notification.dart';
import 'package:nalia_app/services/route_names.dart';

import 'package:rxdart/subjects.dart';

import 'package:path_provider/path_provider.dart';

class App {
  BehaviorSubject<bool> firebaseReady = BehaviorSubject.seeded(false);

  // PermissionStatus _permissionGranted;

  /// [dailyBonusAvaiable] is posted true when user can get/redeem their free daily bonus.
  RxBool dailyBonusAvaiable = false.obs;

  PushNotification pushNotification;
  App() {
    initFirebase();

    everyMinutes();
    Timer(Duration(minutes: 1), everyMinutes);
  }

  everyMinutes() async {
    api.authChanges.listen((user) async {
      if (user == null) return;

      try {
        await NaliaController.to.getMyBonusJewelry();
      } catch (e) {
        if (e == ERROR_DAILY_BONUS_NOT_GENERATED) {
          dailyBonusAvaiable.value = true;
        }
      }
    });
  }

  initFirebase() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      firebaseReady.add(true);
      pushNotification = PushNotification();
      pushNotification.init();
    } catch (e) {
      print('--------------> Firebase initialization failed !!');
    }
  }

  /// 프로필이 모두 업데이트 안되었을 때, 이곳으로 온다.
  onErrorProfileReady() async {
    final re = await confirm('note'.tr, ERROR_PROFILE_READY.tr);
    if (re) {
      open(RouteNames.profile);
    }
  }

  error(dynamic e, [String message]) {
    print('=> error(e): ');
    print(e);
    print('=> e.runtimeType: ${e.runtimeType}');

    String title = 'Ooh'.tr;
    String msg = '';

    /// e is title, message is String
    if (message != null) {
      title = e;
      msg = message;
    } else if (e is String) {
      /// Is error string? If error string begins with `ERROR_`, then it might be PHP error or client error.
      if (e.indexOf('ERROR_') == 0) {
        if (e == ERROR_PROFILE_READY) return onErrorProfileReady();
        // 콜론(:) 다음에 추가적인 에러 메시지가 있을 수 있다.
        if (e.indexOf(':') > 0) {
          List<String> arr = e.split(':');
          msg = arr[0].tr + ' : ' + arr[1];
        } else {
          msg = e.tr;
        }
      } else {
        msg = e;
      }
    } else if (e is DioError) {
      print("Got dio error on error(e)");
      print(e.error);
      msg = e.message;
    } else if (e is FirebaseException) {
      print("Got firebase error on error(e)");
      msg = "Firebase Exception: ${e.code}, ${e.message}";
    } else {
      /// other errors.
      print("Got unknown error on error(e)");
      msg = "Unknown error";
    }

    print('error msg: $msg');
    Get.snackbar(
      title,
      msg,
      animationDuration: Duration(milliseconds: 700),
    );
  }

  Future alert(String message) async {
    await Get.defaultDialog(
      title: '알림',
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      textConfirm: '확인',
      onConfirm: () => Get.back(),
      confirmTextColor: Colors.white,
    );
  }

  // bool get locationReady =>
  //     locationServiceChanges.value == true && locationAppPermissionChanges.value == true;

  /// Upload an image.
  ///
  /// It can be used for upload photos for a post, comment, gallery, or even user profile photo.
  /// ```dart
  /// ApiFile file = await app.imageUpload(onProgress: onProgress);
  /// post.files.add(file);
  /// final edited = await api.editPost(id: post.id, files: post.files);
  /// ```
  Future<ApiFile> imageUpload({int quality = 90, Function onProgress}) async {
    /// Ask user
    final re = await Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text('take photo from camera'),
                  onTap: () => Get.back(result: ImageSource.camera)),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('get photo from gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('cancel'),
                onTap: () => Get.back(result: null),
              ),
            ],
          ),
        ),
      ),
    );
    if (re == null) throw ERROR_IMAGE_NOT_SELECTED;

    /// Pick image
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: re);
    if (pickedFile == null) throw ERROR_IMAGE_NOT_SELECTED;

    String localFile = await getAbsoluteTemporaryFilePath(getRandomString() + '.jpeg');
    File file = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path, // source file
      localFile, // target file. Overwrite the source with compressed.
      quality: quality,
    );

    /// Upload
    return await api.uploadFile(file: file, onProgress: onProgress);
  }

  /// 예/아니오를 선택하게 하는 다이얼로그를 표시한다.
  ///
  /// 예를 선택하면 true, 아니오를 선택하면 false 를 리턴한다.
  Future<bool> confirm(String title, String message) async {
    return await showDialog(
      context: Get.context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: Text('yes'.tr),
                ),
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text('no'.tr),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///
  /// ```dart
  /// toast('보석 보너스', '축하합니다. 오늘의 보석 보너스를 받으셨습니다.', duration: 20);
  /// ```
  toast(String title, String message, {Function onTap, Widget icon, int duration = 10}) {
    iconSnackbar(title, message, onTap: onTap, icon: icon, duration: duration);
  }

  /// Opens a warning snackbar
  iconSnackbar(String title, String message, {Function onTap, Widget icon, int duration = 10}) {
    Get.snackbar(
      '',
      null,
      titleText: Text(
        title,
        style: TextStyle(
          fontSize: sm,
          color: Colors.black,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
      colorText: Colors.red,
      duration: Duration(seconds: duration),
      icon: icon ?? Icon(Icons.alarm),
      padding: EdgeInsets.fromLTRB(md, sm, sm, sm),
      mainButton: FlatButton(
        child: Text('확인'),
        onPressed: () {
          if (onTap != null) onTap();
          Get.back();
        },
      ),
      onTap: (snack) {
        if (onTap != null) onTap();
        Get.back();
      },
      animationDuration: Duration(milliseconds: 500),
    );
  }

  /// [downloadImage] download images into local temp folderisBlank
  ///
  /// ```dart
  /// () async {
  /// try {
  ///   File file = await app.downloadImage(
  ///     url: Config.backendSiteUrl + '/tmp/img/1.jpg',
  ///     onProgress: (p) => print('progress: $p%'),
  ///   );
  ///  print(file);
  ///   } catch (e) {
  ///  print('file error:');
  ///  print(e);
  ///   }
  /// }();
  /// ```
  Future<File> downloadImage({@required String url, Function onProgress}) async {
    var tempDir = await getTemporaryDirectory();
    String savePath = tempDir.path + '/' + getFilenameFromPath(url);

    Dio dio = Dio();

    final response = await dio.get(
      url,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          if (onProgress != null) onProgress((received / total * 100).round());
        }
      },
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return File(savePath);
  }

  /// Get the login user's post of gallery. It will create one if none exists.
  Future<ApiPost> getGalleryPost() async {
    if (api.notLoggedIn) return null;
    List<ApiPost> posts = await api.searchPost(category: Config.galleryCategory, limit: 1, author: api.id);
    if (posts.length == 0) {
      print('No gallery post. create one');
      await api.editPost(category: Config.galleryCategory, title: 'My gallery', content: 'My gallery photos');
      posts = await api.searchPost(category: Config.galleryCategory, limit: 1);
    }
    return posts.first;
  }

  /// 보석 전송(추천)
  ///
  /// * 주의: 이 함수에서 에러 처리를 다 한다. 상단에서는 async/await 없이 이 함수를 호출하기만 하면 된다.
  ///
  Future recommend({ApiBio user, String jewelry, String item, int count}) async {
    try {
      await checkUserProfile();
      final res = await NaliaController.to.giveJewelry(
        userId: user.userId,
        jewelry: jewelry,
        count: count,
        item: item,
      );
      print(res);
    } catch (e) {
      if (e == ERROR_NOT_ENOUGH_JEWELRY) {
        app.error((e as String).trArgs([jewelry.tr]));
      } else {
        app.error(e);
      }
    }

    return 0;
  }

  openChatRoom({String roomId, String userId}) async {
    if (api.id == userId) {
      return app.alert('cannot chat to yourself'.tr);
    }
    try {
      await checkUserProfile();
    } catch (e) {
      error(e);
      return;
    }
    app.open(RouteNames.chatRoom, arguments: {'roomId': roomId, 'userId': userId});
  }

  /// Return true if there is no problem on user's profile or throws an error.
  Future<bool> checkUserProfile() async {
    // print("if ($hasName && $hasGener && $hasBirthday)");
    if (api.notLoggedIn) {
      throw ERROR_LOGIN_FIRST;
    }

    if (profileReady == false) throw ERROR_PROFILE_READY;
    return true;
  }

  bool get profileReady =>
      Bio.data.profilePhotoUrl != null &&
      Bio.data.profilePhotoUrl != '' &&
      Bio.data.name != null &&
      Bio.data.name != '';

  bool get profileComplete => api.profileComplete;

  Future<ApiBio> getBio(String userId) async {
    final rows = await api.query("bio", "user_ID=$userId");
    if (rows.length == 0) {
      return null;
    } else {
      return ApiBio.fromJson(rows[0]);
    }
  }

  open(String routeName, {Map<String, dynamic> arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  subscribed(String name) {
    return api.user?.data['subscription_$name'] == 'Y';
  }

  subscribe(String name) async {
    try {
      final re = await api.updateUserMeta('subscription_$name', 'Y');
      print(re.data['subscription_$name']);
    } catch (e) {
      error(e);
    }
  }

  unsubscribe(String name) async {
    try {
      final re = await api.updateUserMeta('subscription_$name', 'N');
      print(re.data['subscription_$name']);
    } catch (e) {
      error(e);
    }
  }

  sendChatPushMessage(ChatRoom chat, String body) async {
    try {
      await api.sendMessageToUsers(
        users: [chat.global.otherUserId],
        subscription: 'subscription_' + chat.id,
        title: 'chat message',
        body: body,
      );
    } catch (e) {
      if (e == ERROR_EMPTY_TOKENS) {
        print('No tokens to sends. It is not a critical error');
      } else {
        error(e);
      }
    }
  }
}
