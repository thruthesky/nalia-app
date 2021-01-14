import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon_animator/icon_animator.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/models/api.user_card.controller.dart';
import 'package:nalia_app/screens/home/home.news_scroller.dart';
import 'package:nalia_app/screens/home/home.user_card.bottom_menu.dart';
import 'package:nalia_app/services/svg_icons.dart';
import 'package:nalia_app/widgets/spinner.dart';
import 'package:nalia_app/widgets/svg_icon.dart';

class HomeUserCardSlides extends StatefulWidget {
  @override
  _HomeUserCardSlidesState createState() => _HomeUserCardSlidesState();
}

class _HomeUserCardSlidesState extends State<HomeUserCardSlides> {
  // List<ApiUser> users = [];
  /// [renderCount] 총 사용자 카드 카운트
  ///
  /// 사용자 카드를 맨 앞에 추가 할 때, 특정 사용자의 카드가 중복으로 추가된다. 이 때,
  /// 맨 처음 표시되는 사용자 카드에만 도움말 표시를 할 때, 사용된다.
  int renderCount = 0;

  @override
  void initState() {
    super.initState();
  }

  renderView(ApiBio user, int index) {
    // print("user.profilePhotoUrl: ${user.profilePhotoUrl}");
    renderCount++;
    return Stack(
      key: Key(user.userId),
      fit: StackFit.expand,
      children: [
        Image(
          image: CachedNetworkImageProvider(user.profilePhotoUrl),
          fit: BoxFit.cover,
        ),
        TopShadow(),
        BottomShadow(),
        HomeUserCardBottomMenu(
          user,
          onClickThumbnail: (url) {
            print('image clicked: $url');
            setState(() => user.profilePhotoUrl = url);
          },
          onReset: () {
            UserCardController.of.pageController.jumpToPage(0);
          },
        ),
        if (index == 0 && renderCount == 1)
          Positioned(
            child: Center(
              child: IconAnimator(
                loop: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Color(0xa0a0a0a0),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Color(0x55a0a0a0),
                          spreadRadius: 5,
                          offset: Offset(1.0, 1.0),
                        )
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 84,
                        height: 64,
                        child: IconAnimator(
                          loop: 2,
                          children: [
                            AnimationFrame(
                              duration: 500,
                              child: Align(
                                child: SvgIcon(leftSwipeSvg, color: Colors.white, width: 64),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            AnimationFrame(
                              duration: 1000,
                              child: Align(
                                child: SvgIcon(leftSwipeSvg, color: Colors.white, width: 64),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        '다음 사진을 보시려면,\n왼쪽으로 밀어주세요.',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                finish: SizedBox.shrink(),
                children: [
                  AnimationFrame(duration: 1000, child: SizedBox.shrink()),
                  AnimationFrame(duration: 5000),
                ],
              ),
            ),
            top: 180,
            left: 0,
            right: 0,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserCardController>(
      builder: (_) {
        if (_.users.length == 0) return Spinner();

        return Stack(children: [
          PageView(
            allowImplicitScrolling: false,
            children: [
              for (int i = 0; i < _.users.length; i++) renderView(_.users.elementAt(i), i),
            ],
            onPageChanged: (int page) {
              // 사용자 카드가 끝에서 다섯 장 남았을 때, 다음 배치를 로드한다.
              final bool shouldLoad = _.users.length < (page + 5);
              if (shouldLoad) {
                _.fetchUsers();
              }
            },
            controller: _.pageController,
          ),
          HomeNewsScroller(),
        ]);
      },
    );
  }
}

class TopShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0, -0.75),
          colors: <Color>[Color(0xC0000000), Color(0x00000000)],
        ),
      ),
    );
  }
}

class BottomShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment(0, .5),
          colors: <Color>[Color(0xC0000000), Color(0x00000000)],
        ),
      ),
    );
  }
}
