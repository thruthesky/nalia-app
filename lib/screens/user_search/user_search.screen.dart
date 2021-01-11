import 'package:flutter/material.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:get/get.dart';

class ApiUserSearch {
  ApiUserSearch({
    this.fromAge,
    this.toAge,
    this.fromHeight,
    this.toHeight,
    this.fromWeight,
    this.toWeight,
  });
  int fromAge = 0;
  int toAge = 0;

  int fromHeight = 0;
  int toHeight = 0;

  int fromWeight = 0;
  int toWeight = 0;

  toJson() {
    return {
      'fromAge': fromAge,
      'toAge': toAge,
      'fromHeight': fromHeight,
      'toHeight': fromHeight,
      'fromWeight': fromWeight,
      'toWeight': toWeight,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  bool loggedIn = false;

  /// Ages range is from 0 to 79.
  final options = ApiUserSearch(
    fromAge: 0,
    toAge: 0,
    fromHeight: 0,
    fromWeight: 0,
    toHeight: 0,
    toWeight: 0,
  );

  buildChoice({bool selected = false, String text, Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.fromLTRB(sm, xs, sm, xs),
        decoration: BoxDecoration(
          color: selected ? Colors.amber[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(sm),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 10),
        ),
      ),
      onTap: onTap,
    );
  }

  onSearchOptionChanged() async {
    setState(() {});
    print(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: Column(
          children: [
            Text('User search'),
            Wrap(
              children: [
                buildChoice(
                  selected: options.fromAge > 0,
                  text: options.fromAge > 0
                      ? 'Age ${options.fromAge}~${options.toAge}'
                          .trArgs(['${options.fromAge}', '${options.toAge}'])
                      : 'age'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (_, setState) {
                            return AlertDialog(
                              content: Row(
                                children: [
                                  Text('age'.tr),
                                  DropdownButton<int>(
                                    value: options.fromAge,
                                    onChanged: (x) {
                                      setState(() {
                                        options.fromAge = x;
                                        if (options.toAge < options.fromAge) {
                                          options.toAge = options.fromAge + 9;
                                        }
                                      });
                                      onSearchOptionChanged();
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Text('all'.tr),
                                      ),
                                      for (int i = 20; i < 60; i++)
                                        DropdownMenuItem(
                                          value: i,
                                          child:
                                              Text('fromAge %s'.trArgs(['$i'])),
                                        ),
                                    ],
                                  ),
                                  if (options.fromAge > 0)
                                    DropdownButton<int>(
                                      value: options.toAge,
                                      onChanged: (x) {
                                        if (x < options.fromAge) {
                                          x = options.fromAge + 9;
                                          app.alert(
                                              'toAge is smaller than fromAge'
                                                  .tr);
                                        }
                                        setState(() {
                                          options.toAge = x;
                                        });
                                        onSearchOptionChanged();
                                      },
                                      items: [
                                        for (int i = options.fromAge + 1;
                                            i < 80;
                                            i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child:
                                                Text('toAge %s'.trArgs(['$i'])),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    child: Text('@Ok'.tr),
                                    onPressed: () => Get.back()),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                buildChoice(
                  selected: options.fromHeight != 0,
                  text: options.fromHeight != 0
                      ? 'Height ${options.fromHeight}~${options.toHeight}'
                          .trArgs(
                              ['${options.fromHeight}', '${options.toHeight}'])
                      : 'Height'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (_, setState) {
                            return AlertDialog(
                              content: Row(
                                children: [
                                  Text('weight'.tr),
                                  DropdownButton<int>(
                                    value: options.fromHeight,
                                    onChanged: (x) {
                                      setState(
                                        () {
                                          options.fromHeight = x;
                                          if (options.toHeight <
                                              options.fromHeight) {
                                            options.toHeight = HeightGroups[
                                                HeightGroups.indexWhere((h) =>
                                                        h ==
                                                        options.fromHeight) +
                                                    1];
                                          }
                                        },
                                      );
                                      onSearchOptionChanged();
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Text('all'.tr),
                                      ),
                                      for (var h in HeightGroups)
                                        DropdownMenuItem(
                                          value: h,
                                          child: Text(
                                              'fromHeight %s'.trArgs(['$h'])),
                                        ),
                                    ],
                                  ),
                                  if (options.fromHeight > 0)
                                    DropdownButton<int>(
                                      value: options.toHeight,
                                      onChanged: (x) {
                                        if (x < options.fromHeight) {
                                          // x = options.fromHeight + 9;
                                          print('F');
                                          options.toHeight = HeightGroups[
                                              HeightGroups.indexWhere((h) =>
                                                      h == options.fromHeight) +
                                                  1];
                                          app.alert(
                                              'toHeight is smaller than fromHeight'
                                                  .tr);
                                        }
                                        setState(() {
                                          options.toHeight = x;
                                        });
                                        onSearchOptionChanged();
                                      },
                                      items: [
                                        for (int h in HeightGroups)
                                          DropdownMenuItem(
                                            value: h,
                                            child: Text(
                                                'toHeight %s'.trArgs(['$h'])),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    child: Text('@Ok'.tr),
                                    onPressed: () => Get.back()),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
