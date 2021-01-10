import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';

/// Note that this method is on an isolated space.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("_firebaseMessagingBackgroundHandler(): ${message.messageId}");
}

class PushNotification {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String token;
  init() {
    initFirebaseMessaging();
  }

  initFirebaseMessaging() async {
    // Permission request for iOS
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          break;
        case AuthorizationStatus.denied:
          onNotificationPermissionDenied();
          break;
        case AuthorizationStatus.notDetermined:
          onNotificationPermissionNotDetermined();
          break;
        case AuthorizationStatus.provisional:
          break;
      }
    }

    // Handler, when app is on Foreground.
    FirebaseMessaging.onMessage.listen(onForegroundMessage);

    // Handler, when app is terminated or on background.
    // Note that this is an isolated handler that cannot communicate with main isolate.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Check if app is opened from terminated state and get message data.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onMessageOpenedFromTermiated(initialMessage);
    }

    // Check if the app is opened from the background state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpenedFromBackground(message);
    });

    // Get the token each time the application loads and save it to database.
    token = await FirebaseMessaging.instance.getToken();
    saveTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  /// Save the token to database.
  saveTokenToDatabase(String token) {
    this.token = token;
    print('saveTokenToDatabase: $token');
  }

  /// Forground Message
  ///
  /// [message.data] would something like `{a: apple}`
  ///
  /// Test on iOS. not on Android.
  onForegroundMessage(RemoteMessage message) {
    print('onForegroundMessage()');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
          'Messsage: ${message.notification.title}, ${message.notification.body}');
    }
  }

  /// This will be invoked when the app is opened from terminated state.
  ///
  /// Test on iOS. not on Android.
  onMessageOpenedFromTermiated(RemoteMessage initialMessage) {
    String str = "onMessageOpenedFromTermiated."
        " Message: ${initialMessage.notification.title}, ${initialMessage.notification.body}"
        " data: ${initialMessage?.data}";
    app.alert(str);
    // If it the message has data, then do some exttra work based on the data.
    if (initialMessage?.data['type'] == 'post') {
      Get.toNamed(RouteNames.forumList,
          arguments: {'id', initialMessage.data['id']});
    }
  }

  /// This will be invoked when the app is opened from backgroun state.
  ///
  /// Test on iOS. not on Android.
  onMessageOpenedFromBackground(RemoteMessage message) {
    print("onMessageOpenedFromBackground."
        " Message: ${message.notification.title}, ${message.notification.body}. data: ${message.data}");
    if (message.data['type'] == 'post') {
      Get.toNamed(RouteNames.forumList, arguments: {'id', message.data['id']});
    }
  }

  /// User denied push notification
  ///
  /// What to do: App may show a dialog box to open Device Settings and grant the permission.
  onNotificationPermissionDenied() {
    print('onNotificationPermissionDenied()');
  }

  /// User didn't grant, nor denied the permission, yet.
  onNotificationPermissionNotDetermined() {
    print('onNotificationPermissionNotDetermined()');
  }
}
