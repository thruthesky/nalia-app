import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:nalia_app/screens/home/home.user_card_slide_thumbnails.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firelamp/firelamp.dart';

class HomeUserCardBottomMenu extends StatefulWidget {
  HomeUserCardBottomMenu(this.user, {@required this.onClickThumbnail, @required this.onReset});
  final ApiBio user;
  final Function onClickThumbnail;
  final Function onReset;
  @override
  _HomeUserCardBottomMenuState createState() => _HomeUserCardBottomMenuState();
}

class _HomeUserCardBottomMenuState extends State<HomeUserCardBottomMenu> {
  Widget heartIcon(ApiBio user) {
    return IconButton(
      icon: Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: Icon(
          FontAwesome5Solid.heart,
          color: Colors.deepOrange[400],
          size: md - 2,
        ),
      ),
      onPressed: () async {
        print('heart:');
        try {
          final res = await app.recommend(
            user: user,
            jewelry: SILVER,
          );
          print(res);
        } catch (e) {
          if (e == ERROR_NOT_ENOUGH_JEWELRY) {
            app.error((e as String).trArgs([SILVER.tr]));
          } else {
            app.error(e);
          }
        }
      },
    );
  }

  Widget ringIcon(ApiBio user) {
    return IconButton(
      icon: Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: Icon(
          MaterialCommunityIcons.ring,
          color: Colors.yellow[700],
          size: md + 3,
        ),
      ),
      onPressed: () async {
        print('ring:');
        try {
          final res = await app.recommend(
            user: user,
            jewelry: GOLD,
            item: RING,
          );
          print(res);
        } catch (e) {
          if (e == ERROR_NOT_ENOUGH_JEWELRY) {
            app.error((e as String).trArgs([GOLD.tr]));
          } else {
            app.error(e);
          }
        }
      },
    );
  }

  Widget watchIcon(ApiBio user) {
    return IconButton(
      icon: Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Icon(
          Feather.watch,
          color: Colors.lime[500],
          size: md,
        ),
      ),
      onPressed: () async {
        print('watch:');
        try {
          final res = await app.recommend(
            user: user,
            jewelry: GOLD,
            item: WATCH,
          );
          print(res);
        } catch (e) {
          if (e == ERROR_NOT_ENOUGH_JEWELRY) {
            app.error((e as String).trArgs([GOLD.tr]));
          } else {
            app.error(e);
          }
        }
      },
    );
  }

  Widget bagIcon(ApiBio user) {
    return IconButton(
      icon: Icon(
        SimpleLineIcons.handbag,
        color: Colors.yellow[200],
        size: md - 1,
      ),
      onPressed: () => app.recommend(
        user: user,
        jewelry: GOLD,
        item: BAG,
        count: 3,
      ),

      // print('bag:');
      // try {
      //   final res = await app.recommend(
      //     user: user,
      //     jewelry: GOLD,
      //     item: BAG,
      //   );
      //   print(res);
      // } catch (e) {
      //   if (e == ERROR_NOT_ENOUGH_JEWELRY) {
      //     app.error((e as String).trArgs([GOLD.tr]));
      //   } else {
      //     app.error(e);
      //   }
      // }
      // },
    );
  }

  Widget diamondIcon(ApiBio user) {
    return IconButton(
      icon: Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Icon(
          FontAwesome5Solid.gem,
          color: Colors.white,
          size: sm + 4,
        ),
      ),
      onPressed: () async {
        print('diamond:');
        try {
          final res = await app.recommend(
            user: user,
            jewelry: DIAMOND,
          );
          print(res);
        } catch (e) {
          if (e == ERROR_NOT_ENOUGH_JEWELRY) {
            app.error((e as String).trArgs([DIAMOND.tr]));
          } else {
            app.error(e);
          }
        }
      },
    );
  }

  Widget buildJewelryStat() {
    return LineChart(
      width: 40, // Width size of chart
      height: 30, // Height size of chart
      data: [
        LineChartModel(amount: 300, date: DateTime(2020, 1, 1)),
        LineChartModel(amount: 500, date: DateTime(2020, 1, 2)),
        LineChartModel(amount: 100, date: DateTime(2020, 1, 3)),
        LineChartModel(amount: 900, date: DateTime(2020, 1, 4)),
        LineChartModel(amount: 120, date: DateTime(2020, 1, 5)),
        LineChartModel(amount: 590, date: DateTime(2020, 1, 6)),
        LineChartModel(amount: 300, date: DateTime(2020, 1, 7)),
        LineChartModel(amount: 590, date: DateTime(2020, 1, 6)),
      ], // The value to the chart
      linePaint: Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..color = Colors.white, // Custom paint for the line
      circlePaint: Paint()..color = Colors.amber, // Custom paint for the line
      showPointer:
          true, // When press or pan update the chart, create a pointer in approximated value (The default is true)
      showCircles: true, // Show the circle in every value of chart
      customDraw: (Canvas canvas,
          Size
              size) {}, // You can draw anything in your chart, this callback is called when is generating the chart
      circleRadiusValue: 0, // The radius value of circle
    );
  }

  /// 나와의 관계
  ///
  /// TODO 사용자 카드 나와의 관계: https://docs.google.com/document/d/1plrZXoUNS5cb4XXzHy_LZap6-XfY1oZ_0D9IfOqUbI4/edit#heading=h.an2fgrn11joz
  buildRelation() {
    return CircularPercentIndicator(
      radius: 42.0,
      lineWidth: 4.0,
      animation: true,
      percent: 0.7,
      center: new Text(
        "44",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.purple,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    // print('bottom menu: ${user.uid}');

    return Positioned(
      bottom: 0,
      left: xs,
      right: xs,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRelation(),
                        spaceXs,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            buildJewelryStat(),
                            Text(
                              ' 7.2k',
                              style: TextStyle(color: Colors.white70),
                            )
                          ],
                        ),
                        spaceSm,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: user.name,
                                style: TextStyle(fontSize: md, color: Colors.white),
                              ),
                              TextSpan(
                                text: ' ${user.age} 세',
                                // text: ' ' + app.age(user.birthday).toString() + '세',
                                style: TextStyle(fontSize: sm, color: Colors.white),
                              ),
                              if (user.distance != null)
                                TextSpan(
                                  text: ' ${user.distance} Km 거리',
                                  style: TextStyle(fontSize: xsm, color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                        spaceXxs,
                        Text(
                          "user.dateMethod",
                          style: TextStyle(color: Colors.white70),
                        ),
                        spaceXxs,
                        Text(
                          '#취미',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HomeUserCardSlideThumbnails(
                      user,
                      onClickThumbnail: widget.onClickThumbnail,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.report,
                        color: Colors.red[700],
                        size: lg,
                      ),
                      onPressed: () {},
                    ),

                    /// 사용자 활동량
                    /// TODO https://docs.google.com/document/d/1plrZXoUNS5cb4XXzHy_LZap6-XfY1oZ_0D9IfOqUbI4/edit#heading=h.9jrb4knlw95g

                    Padding(
                      padding: EdgeInsets.only(left: xxs),
                      child: AudioWave(
                        height: 28,
                        width: 38,
                        spacing: 3.5,
                        alignment: 'center',
                        animationLoop: 3,
                        bars: [
                          AudioWaveBar(height: 10, color: Colors.white),
                          AudioWaveBar(height: 50, color: Colors.white),
                          AudioWaveBar(height: 100, color: Colors.white),
                          AudioWaveBar(height: 50, color: Colors.white),
                          AudioWaveBar(height: 10, color: Colors.white),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      onPressed: () => app.openChatRoom(userId: user.userId),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.replay_outlined,
                          color: Colors.white,
                        ),
                        onPressed: widget.onReset),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('search');
                          // app.homeStackChange(HomeStack.userSearch);
                          app.open(RouteNames.userSearch);
                        }),
                  ],
                ),
                Row(
                  children: [
                    heartIcon(user),
                    ringIcon(user),
                    watchIcon(user),
                    bagIcon(user),
                    diamondIcon(user),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
