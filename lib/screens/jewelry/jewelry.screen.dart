import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.daily_bonus.model.dart';
import 'package:nalia_app/models/api.nalia.controller.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:get/get.dart';

// 여기서 부터. 백엔드 jewelry 전송 테스트. 작성하고, 여기 부터 할 것.
class JewelryScreen extends StatefulWidget {
  @override
  _JewelryScreenState createState() => _JewelryScreenState();
}

class _JewelryScreenState extends State<JewelryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.jewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: Container(
          child: Column(
            children: [
              Text('오늘 보너스 보석'),
              DisplayDailyBonus(),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayDailyBonus extends StatefulWidget {
  const DisplayDailyBonus({
    Key key,
  }) : super(key: key);

  @override
  _DisplayDailyBonusState createState() => _DisplayDailyBonusState();
}

class _DisplayDailyBonusState extends State<DisplayDailyBonus> {
  DailyBonus bonus;

  @override
  void initState() {
    super.initState();

    () async {
      try {
        bonus = await NaliaController.to.getMyBonusJewelry();
        print(bonus);
        setState(() => null);
      } catch (e) {
        if (e == ERROR_DAILY_BONUS_NOT_GENERATED) {
          /// fine. user can generate bonus.
        }
        print(e);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(() {
            if (app.dailyBonusAvaiable.value == false) {
              return SizedBox.shrink();
            }
            return RaisedButton(
                child: Text('Generate Free Daily Bonus'),
                onPressed: () async {
                  try {
                    bonus = await NaliaController.to.generateTodayBonus();
                    app.dailyBonusAvaiable.value = false;
                    setState(() {});
                  } catch (e) {
                    if (ERROR_DAILY_BONUS_GENERATED_ALREADY == e)
                      app.error(ERROR_DAILY_BONUS_GENERATED_ALREADY);
                    else
                      app.error(e);
                  }
                });
          }),
          if (bonus != null)
            Text("Today's jewelry bonus:"
                "Date:  ${bonus.date},"
                "Silver: ${bonus.silver},"
                "Gold: ${bonus.gold},"
                "Diamond: ${bonus.diamond} "),
        ],
      ),
    );
  }
}
