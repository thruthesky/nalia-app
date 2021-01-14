import 'package:get/get.dart';
import 'package:nalia_app/models/api.daily_bonus.model.dart';
import 'package:nalia_app/services/global.dart';

class NaliaController extends GetxController {
  static final NaliaController to = Get.find<NaliaController>();

  Future<DailyBonus> getMyBonusJewelry() async {
    final data = await api.request({
      'route': 'nalia.getMyBonusJewelry',
    });

    return DailyBonus.fromJson(data);
  }

  Future<DailyBonus> generateTodayBonus() async {
    final data = await api.request({
      'route': 'nalia.generateTodayBonus',
    });

    return DailyBonus.fromJson(data);
  }

  Future<DailyBonus> giveJweelry() async {
    final data = await api.request({
      'route': 'nalia.giveJweelry',
    });

    return DailyBonus.fromJson(data);
  }
}
