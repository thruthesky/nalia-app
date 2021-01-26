import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:withcenter/withcenter.dart';

/// Note that this method is on an isolated space.
///
/// It works only on Android. it is not designed for iOS.
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print(
//       "_firebaseMessagingBackgroundHandler(): ${message.messageId}, ${message.notification.title}, ${message.notification.body}");
// }

class PushNotification {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String token;
  init() async {
    try {
      await initFirebaseMessaging();
    } catch (e) {
      print('==> ERROR: Failed on PushNotification.init() e:');
      print(e);
    }
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

      // print('--> push_notification.dart User granted permission: ${settings.authorizationStatus}');

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
    // For Android only.
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Check if app is opened from terminated state and get message data.
    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
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

    // When ever user logs in, update the token with user Id.
    withcenterApi.authChanges.listen((user) {
      if (user == null) return;
      // print('Saving token on user auth chagnes: $token');
      saveTokenToDatabase(token);
    });
  }

  /// Save the token to database.
  saveTokenToDatabase(String token) async {
    this.token = token;
    try {
      await withcenterApi.updateToken(token);
    } catch (e) {
      print('error saveTokenToDatabase: $token');
      app.error(e);
    }
  }

  /// Forground Message
  ///
  /// [message.data] would something like `{a: apple}`
  ///
  /// Test on both Android device, Emulator, and iOS device. Simulator is not working.
  onForegroundMessage(RemoteMessage message) {
    print('onForegroundMessage()');
    print('Message data: ${message?.data}');

    app.toast(message.notification.title, message.notification.body);

    if (message.notification != null) {
      print('Messsage: ${message.notification.title}, ${message.notification.body}');
    }

    if (message?.data['type'] == 'post') {
      app.open(RouteNames.forumList, arguments: {'id': message.data['id']});
    }
  }

  /// This will be invoked when the app is opened from terminated state.
  ///
  /// Test on both Android device, Emulator, and iOS device. Simulator is not working.
  onMessageOpenedFromTermiated(RemoteMessage initialMessage) {
    String str = "onMessageOpenedFromTermiated."
        " Message: ${initialMessage.notification.title}, ${initialMessage.notification.body}"
        " data: ${initialMessage?.data}";
    app.alert(str);
    // If it the message has data, then do some exttra work based on the data.
    if (initialMessage?.data['type'] == 'post') {
      app.open(RouteNames.forumList, arguments: {'id': initialMessage.data['id']});
    }
  }

  /// This will be invoked when the app is opened from backgroun state.
  ///
  /// Test on both Android device, Emulator, and iOS device. Simulator is not working.
  onMessageOpenedFromBackground(RemoteMessage message) {
    print("onMessageOpenedFromBackground."
        " Message: ${message.notification.title}, ${message.notification.body}. data: ${message.data}");
    if (message.data['type'] == 'post') {
      app.open(RouteNames.forumList, arguments: {'id': message.data['id']});
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
