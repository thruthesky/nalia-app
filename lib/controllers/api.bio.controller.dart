import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/services/global.dart';

class Bio extends GetxController {
  static Bio to = Get.find<Bio>();
  static ApiBio data;
  bool ready = false;
  @override
  void onInit() {
    super.onInit();

    api.authChanges.listen((user) {
      if (user == null) {
        Bio.data = null;
      } else {
        getBio().then((bio) {
          Bio.data = bio;
          ready = true;
          update();
        });
      }
    });
  }

  Future<ApiBio> updateBio(String code, String value) async {
    final re = await api.appUpdate('bio', code, value);
    data = ApiBio.fromJson(re);
    update();
    return data;
  }

  Future<ApiBio> getBio() async {
    final re = await api.appGet('bio');
    return ApiBio.fromJson(re);
  }

  Future<List<ApiBio>> search({
    double latitude,
    double longitude,
    double km,
    int limit = 1500,
  }) async {
    final re = await api.request({
      'route': 'bio.search',
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'latitude': longitude,
      if (km != null) 'latitude': km,
      'limit': limit,
      'hasProfilePhoto': 'Y',
      'orderby': 'RAND()',
    });
    final List<ApiBio> bios = [];
    for (final b in re) bios.add(ApiBio.fromJson(b));
    return bios;
  }
}
