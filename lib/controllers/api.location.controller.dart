import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';

class LocationController extends GetxController {
  static LocationController to = Get.find<LocationController>();
  static LocationController of = Get.find<LocationController>();

  Location location = Location();

  /// Location 이 사용가능한 상태이면, 내 위치를 [myLocation] 에 보관한다.
  LocationData myLocation;
  bool serviceEnabled = false;
  bool permissionGranted = false;
  PermissionStatus _permissionGranted;

  /// Location(내 위치) 서비스가 Enable 되었고, 앱에 권한이 있으면 true
  bool get ready => serviceEnabled && permissionGranted;

  /// [ready] 의 값(권한이 있는지 없는지)을 이벤트로 발생시킨다.
  /// 이 이벤트가 false 값으로 전달되는 경우, serviceEnabled 또는 permissionGranted 를 참고해서,
  /// 서비스가 Enable 되지 않았는지 또는 앱 권한이 없는지 확인 할 수 있다.
  /// 참고로 앱이 부팅 할 때, 처음에는 null 이벤트가 발생하며, 그 이후, Location 기능이 사용가능하면 true, 아니면 false 가 한번 발생하게 된다.
  ///
  /// 예제)
  /// ```
  /// LocationController.of.locationServiceChanges.listen((re) async {
  ///   if (re == null) return;
  ///   /* 여기에 코드가 오면, Location 이 사용 가능한지 아닌지 확인된상태이다. */
  ///   await fetchUsers();
  /// });
  /// ```
  BehaviorSubject<bool> locationServiceChanges = BehaviorSubject.seeded(null);

  @override
  void onInit() {
    super.onInit();

    checkLocation();
  }

  /// 필요한 경우 언제든지 [checkLocation]을 호출해서, Location 기능이 사용가능한지 확인을 해 볼 수 있다.
  /// 예를 들어, Location 기능이 사용가능한지 아닌지에 따라서 동작을 달리해야 할 경우, [locationServiceChanges] 이벤트를 listen 해도 되겠지만,
  /// 바로 `re = await checkLocation()` 와 같이 해도 된다.
  Future<bool> checkLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    if (serviceEnabled == false) {
      // location.serviceEnabled 와 같이 참조 가능
      locationServiceChanges.add(ready);
      return false;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
      locationServiceChanges.add(ready);
      return false;
    }

    // 나의 위치를 한번 읽는다.
    myLocation = await location.getLocation();

    // location.permissionGranted 와 같이 참조 가능
    locationServiceChanges.add(ready);
    return ready;
  }
}
