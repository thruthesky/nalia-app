import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:nalia_app/services/global.dart';
// import 'package:get_storage/get_storage.dart';

class App {
  App() {
    // initLocalStorage();
  }

  initLocalStorage() {
    // GetStorage.init().then((b) {
    //   localStorage = GetStorage();
    //   localStorageReady.add(true);
    // });

    // localStorageReady.listen((v) {
    //   if (v == false) return;
    //   // initLocation();
    // });
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
      msg = e;
    } else {}

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
}
