// import 'package:nalia_app/controllers/api.controller.dart';
import 'package:nalia_app/services/app.dart';
import 'package:nalia_app/services/in_app_purchase.service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firechat/firechat.dart';
import 'package:withcenter/withcenter.dart';

final App app = App();

final WithcenterApi api = withcenterApi;

///
// final API api = API();

/// [chat] is the chat room instance.
///
/// The reason why it is declared in global scope is that the app needs to know
/// if the user is in a chat room. So, when he gets a push notification from the
/// chat room where he is in, the push messge will be ignored.
ChatRoom chat;

/// [myRoomList] is the instance of ChatMyRoomList. It will be instanciated in
/// main.dart
ChatMyRoomList myRoomList;

/// [myRoomListChanges] will be fired whenever/whatever events happens for my
/// chat room list.
BehaviorSubject myRoomListChanges = BehaviorSubject.seeded(null);

final InAppPurchaseService iapService = InAppPurchaseService();
