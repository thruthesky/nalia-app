import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/controllers/api.location.controller.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/services/global.dart';

class UserCardController extends GetxController {
  static UserCardController get to => Get.find<UserCardController>();
  static UserCardController get of => Get.find<UserCardController>();

  final PageController pageController = PageController();

  List<ApiBio> users = [];
  Timer _timer;
  @override
  void onInit() {
    super.onInit();
    // 문제. 앱 부팅시, Location 기능 확인이 느린편이며, async 방식으로 확인을 하는데, 앱이 부팅되고 한참 후에 확인(Enable 또는 Disable)가능하다.
    // 또한, 권한 획득을 위해서 다이얼로그를 보여주는데, 그 다이얼로그에서 사용자가 선택을 하기 전까지는 확인 루틴이 멈추게 된다.
    // 즉, 처음 앱 부팅 후, Location 가능 확인 작업이 매우 느리거나 알 수 없는 상태에 빠지며, 특히 Android 에서 .getLocation() 으로 현재 사용자 위치 값을 가져오는 것이 매우 느리다.
    // 이와 같이 느린 경우, 사용자에게는 초기 정보를 보여주기 위해서, 먼저 서버에 한번 접속을 해야하는데, 너무 많은 정보를 가져오려는 경우 부담된다.
    // 해결책으로는 Location 이 확인되지 않으면, 최소한의 정보만 가져오는 것이다. 예를 들면, 회원 정보 100개 가아닌 10개만 먼저 가져오는 것이다.
    // 하지만 이로 인해 화면 blinking 이 발생한다. 따라서, 최선의 방법은 한번만 가져오는 것이다.
    _timer = Timer(Duration(milliseconds: 100), fetchUsers);
    LocationController.of.locationServiceChanges.listen((re) async {
      if (re == null) return;
      // 여기에 코드가 오면, Location 이 사용 가능한지 아닌지 확인된상태이다.
      _timer.cancel();
      await fetchUsers();
    });
  }

  fetchUsers() async {
    print("-----> location ready: ${LocationController.of.ready}");
    users = await search();
    print('-----> Search result: users:');
    // print(users);
    update();
    // Query q = ff.publicCol;

    // q = q.orderBy('listOrder', descending: true);
    // if (users.length > 0) q = q.startAfter([users.last.listOrder]);
    // q = q.limit(_limit);

    // _inLoading = true;
    // print('fetchNo: $_fetchNo');
    // QuerySnapshot snapshot = await q.get();
    // _fetchNo++;
    // _inLoading = false;
    // print('fetch No: $_fetchNo, fetch snapshot.size: ${snapshot.size}');

    // if (snapshot.size == 0) {
    //   _noMoreUsers = true;
    // } else {
    //   snapshot.docs.forEach((DocumentSnapshot doc) {
    //     final _user = AppUser.fromSnaphot(doc);
    //     if (_user.fine) {
    //       users.add(_user);
    //       // 사진을 미리 로드해서 빠르게 보여 줌
    //       precacheImage(
    //         CachedNetworkImageProvider(_user.primaryPhoto),
    //         Get.context,
    //       );
    //     } else {
    //       print("User ${_user.fullName} is not fine!");
    //     }
    //   });

    // update();
    // if (snapshot.size < _limit) {
    //   _noMoreUsers = true;
    // }
    // }
  }

  /// [user] 를 [users] 배열 맨 처음에 추가하고, reset 표시를 한다.
  ///
  /// update() 에 의해서, reset 이 표시되었으면, 사용자 카드를 맨 앞으로 돌린다.
  /// 결과적으로 맨 앞에 추가하는 [user] 가 사용자 카드 페이지(스택)에 나오도록 하는 것이다.
  ///
  /// 예를 들어, 사용자 검색에서, 특정 사용자를 클릭하면, 사용자 카드 페이지로 이동하고, 그 사용자가
  /// 나오도록 할 때 사용 할 수 있다.
  insertUser(ApiBio user) {
    users.insert(0, user);
    update();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(0);
    });
  }

  /// 사용자 검색
  ///
  /// bio 테이블에서 사용자 정보 추출. 위치 정보가 있으면, 현재 사용자 주위의 사용자만 검색
  Future<List<ApiBio>> search() async {
    double latitude;
    double longitude;
    double km;

    if (LocationController.of.ready) {
      latitude = LocationController.of.myLocation.latitude;
      longitude = LocationController.of.myLocation.longitude;

      // TOOD: 옵션처리
      km = 500.0;
    }

    final req = {
      'route': 'bio.search',
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (km != null) 'km': km,
      'limit': 1500.toString(),
      'hasProfilePhoto': 'Y',
      'orderby': 'RAND()',
    };
    print('req: $req');
    final re = await api.request(req);
    final List<ApiBio> bios = [];
    for (final b in re) bios.add(ApiBio.fromJson(b));
    return bios;
  }
}
