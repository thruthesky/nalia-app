import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/controllers/api.location.controller.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/services/global.dart';

class UserCardController extends GetxController {
  static UserCardController get to => Get.find<UserCardController>();
  static UserCardController get of => Get.find<UserCardController>();

  final PageController pageController = PageController();

  // 한번에 20 장씩 사용자를 로드한다. TODO: 차후, 옵션으로 할 수 있도록 한다.
  // int _limit = 20;
  bool _noMoreUsers = false;
  bool _inLoading = false;
  // int _fetchNo = 0;
  List<ApiBio> users = [];
  @override
  void onInit() {
    super.onInit();
    LocationController.of.locationServiceChanges.listen((re) async {
      if (re == null) return;
      print("ready: ${LocationController.of.ready}");
      // 여기에 코드가 오면, Location 이 사용 가능한지 아닌지 확인된상태이다.
      await fetchUsers();
    });
  }

  fetchUsers() async {
    if (_noMoreUsers) {
      print('noMoreUsers: ');
      return;
    }
    if (_inLoading) {
      print('inLoading:');
      return;
    }

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
      'limit': 1500,
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
