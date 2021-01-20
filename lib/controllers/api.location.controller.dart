import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';

class LocationController extends GetxController {
  static LocationController to = Get.find<LocationController>();

  Location location = Location();
  bool serviceEnabled = false;
  bool permissionGranted = false;
  PermissionStatus _permissionGranted;

  /// Location(내 위치) 서비스가 Enable 되었고, 앱에 권한이 있으면 true
  bool get ready => serviceEnabled && permissionGranted;

  /// [ready] 의 값(권한이 있는지 없는지)을 이벤트로 발생시킨다.
  /// 이 이벤트가 false 값으로 전달되는 경우, serviceEnabled 또는 permissionGranted 를 참고해서,
  /// 서비스가 Enable 되지 않았는지 또는 앱 권한이 없는지 확인 할 수 있다.
  BehaviorSubject<bool> locationServiceChanges = BehaviorSubject.seeded(false);
  @override
  void onInit() {
    super.onInit();

    checkLocation();
  }

  /// You can call [checkLocation] whenever you need to check if the service and permission are given.
  checkLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    // location.serviceEnabled 와 같이 참조 가능
    locationServiceChanges.add(ready);

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
    }

    // location.permissionGranted 와 같이 참조 가능
    locationServiceChanges.add(ready);
  }
}
