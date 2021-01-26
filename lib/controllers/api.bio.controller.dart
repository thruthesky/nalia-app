import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';

class Bio extends GetxController {
  static Bio to = Get.find<Bio>();
  static ApiBio data;
  bool get ready => data != null;
  @override
  void onInit() {
    super.onInit();

    api.authChanges.listen((user) async {
      if (user == null) {
        data = null;
      } else {
        try {
          data = await getMyBioRecord();
          update();
        } catch (e) {
          if (e == ERROR_EMPTY_RESPONSE) {
            data = ApiBio.fromJson({});
            print("bio data: $data");
          } else {
            app.error(e);
          }
        }
      }
    });
  }

  Future<ApiBio> updateBio(String code, String value) async {
    final re = await api.appUpdate(BIO_TABLE, code, value);
    data = ApiBio.fromJson(re);
    update();
    return data;
  }

  Future<ApiBio> getMyBioRecord() async {
    final re = await api.appGet(BIO_TABLE);
    return ApiBio.fromJson(re);
  }
}
