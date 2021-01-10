import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/helper.functions.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:nalia_app/services/push_notification.dart';

import 'package:rxdart/subjects.dart';

class App {
  Location location = Location();
  bool locationServiceEnabled = false;
  RxBool locationServiceChanges = false.obs;
  RxBool locationAppPermissionChanges = false.obs;
  BehaviorSubject<bool> firebaseReady = BehaviorSubject.seeded(false);
  // PermissionStatus _permissionGranted;

  /// [justGotDailyBonus] is to indiate that the user got bonus.
  RxBool justGotDailyBonus = false.obs;

  PushNotification pushNotification;
  App() {
    initFirebase();
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

  void error(dynamic e, [String message]) {
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
      print(e.error);
      msg = e.message;
    } else {
      /// other errors.
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

  bool get locationReady =>
      locationServiceChanges.value == true &&
      locationAppPermissionChanges.value == true;

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

    String localFile =
        await getAbsoluteTemporaryFilePath(getRandomString() + '.jpeg');
    File file = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path, // source file
      localFile, // target file. Overwrite the source with compressed.
      quality: quality,
    );

    /// Upload
    return await api.uploadFile(file: file, onProgress: onProgress);
  }

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
  toast(String title, String message,
      {Function onTap, Widget icon, int duration = 10}) {
    iconSnackbar(title, message, onTap: onTap, icon: icon, duration: duration);
  }

  /// Opens a warning snackbar
  iconSnackbar(String title, String message,
      {Function onTap, Widget icon, int duration = 10}) {
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
}
