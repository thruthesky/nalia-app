import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/services/global.dart';

class Bio extends GetxController {
  static Bio to = Get.find<Bio>();
  ApiBio data;
  bool ready = false;
  @override
  void onInit() {
    super.onInit();

    getBio().then((bio) {
      this.data = bio;
      ready = true;
      update();
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
}
