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
    this.gender,
    this.fromHeight,
    this.toHeight,
    this.fromWeight,
    this.toWeight,
    this.city,
    this.hobby,
    this.drinking,
    this.smoking,
    this.location,
  });
  int fromAge = 0;
  int toAge = 0;

  String gender;

  int fromHeight = 0;
  int toHeight = 0;

  int fromWeight = 0;
  int toWeight = 0;

  String city;
  String hobby;
  String drinking;
  String smoking;
  int location;

  toJson() {
    return {
      'fromAge': fromAge,
      'toAge': toAge,
      'gender': gender,
      'fromHeight': fromHeight,
      'toHeight': toHeight,
      'fromWeight': fromWeight,
      'toWeight': toWeight,
      'city': city,
      'hobby': hobby,
      'drinking': drinking,
      'smoking': smoking,
      'location': location,
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
                      ? 'Age ${options.fromAge}~${options.toAge}'.trArgs(['${options.fromAge}', '${options.toAge}'])
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
                                          child: Text('fromAge %s'.trArgs(['$i'])),
                                        ),
                                    ],
                                  ),
                                  if (options.fromAge > 0)
                                    DropdownButton<int>(
                                      value: options.toAge,
                                      onChanged: (x) {
                                        if (x < options.fromAge) {
                                          x = options.fromAge + 9;
                                          app.alert('toAge is smaller than fromAge'.tr);
                                        }
                                        setState(() {
                                          options.toAge = x;
                                        });
                                        onSearchOptionChanged();
                                      },
                                      items: [
                                        for (int i = options.fromAge + 1; i < 80; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text('toAge %s'.trArgs(['$i'])),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(child: Text('@Ok'.tr), onPressed: () => Get.back()),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                buildChoice(
                  selected: options.gender != null,
                  text: options.gender == null
                      ? 'gender'.tr
                      : options.gender == 'M'
                          ? 'M'.tr
                          : 'F'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          children: [
                            Text('gender'.tr),
                            DropdownButton<String>(
                              value: options.gender,
                              onChanged: (x) {
                                setState(() {
                                  options.gender = x;
                                });
                                onSearchOptionChanged();
                                Get.back();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('all'.tr),
                                ),
                                DropdownMenuItem(
                                  value: 'M',
                                  child: Text('M'.tr),
                                ),
                                DropdownMenuItem(
                                  value: 'F',
                                  child: Text('F'.tr),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                buildChoice(
                  selected: options.fromHeight != 0,
                  text: options.fromHeight != 0
                      ? '${options.fromHeight}~${options.toHeight}cm'
                          .trArgs(['${options.fromHeight}', '${options.toHeight}'])
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
                                  Text('height'.tr),
                                  DropdownButton<int>(
                                    value: options.fromHeight,
                                    onChanged: (x) {
                                      setState(() {
                                        options.fromHeight = x;
                                        if (options.toHeight <= options.fromHeight) {
                                          options.toHeight =
                                              HeightGroups[HeightGroups.indexWhere((h) => h == options.fromHeight) + 1];
                                        }
                                      });
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
                                          child: Text('from %s'.trArgs(['$h'])),
                                        ),
                                    ],
                                  ),
                                  if (options.fromHeight > 0)
                                    DropdownButton<int>(
                                      value: options.toHeight,
                                      onChanged: (x) {
                                        if (x < options.fromHeight) {
                                          options.toHeight =
                                              HeightGroups[HeightGroups.indexWhere((h) => h == options.fromHeight) + 1];
                                          app.alert('toHeight is smaller than fromHeight'.tr);
                                        }
                                        setState(() {
                                          options.toHeight = x;
                                        });
                                        onSearchOptionChanged();
                                      },
                                      items: [
                                        for (int h in HeightGroups.where((n) => n > options.fromHeight))
                                          DropdownMenuItem(
                                            value: h,
                                            child: Text('to %s'.trArgs(['$h'])),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(child: Text('@Ok'.tr), onPressed: () => Get.back()),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                buildChoice(
                  selected: options.fromWeight != 0,
                  text: options.fromWeight != 0
                      ? '${options.fromWeight}~${options.toWeight}kg'
                          .trArgs(['${options.fromWeight}', '${options.toWeight}'])
                      : 'Weight'.tr,
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
                                    value: options.fromWeight,
                                    onChanged: (x) {
                                      setState(() {
                                        options.fromWeight = x;
                                        if (options.toWeight <= options.fromWeight) {
                                          options.toWeight =
                                              WeightGroups[WeightGroups.indexWhere((h) => h == options.fromWeight) + 1];
                                        }
                                      });
                                      onSearchOptionChanged();
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Text('all'.tr),
                                      ),
                                      for (var h in WeightGroups)
                                        DropdownMenuItem(
                                          value: h,
                                          child: Text('from %s'.trArgs(['$h'])),
                                        ),
                                    ],
                                  ),
                                  if (options.fromWeight > 0)
                                    DropdownButton<int>(
                                      value: options.toWeight,
                                      onChanged: (x) {
                                        if (x < options.fromWeight) {
                                          // print('F');
                                          options.toWeight =
                                              WeightGroups[WeightGroups.indexWhere((h) => h == options.fromWeight) + 1];
                                          app.alert('toWeight is smaller than fromWeight'.tr);
                                        }
                                        setState(() {
                                          options.toWeight = x;
                                        });
                                        onSearchOptionChanged();
                                      },
                                      items: [
                                        for (int h in WeightGroups.where((n) => n > options.fromWeight))
                                          DropdownMenuItem(
                                            value: h,
                                            child: Text('to %s'.trArgs(['$h'])),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(child: Text('@Ok'.tr), onPressed: () => Get.back()),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                buildChoice(
                  selected: options.city != null,
                  text: options.city == null ? 'city'.tr : options.city,
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          children: [
                            Text('city'.tr),
                            DropdownButton<String>(
                              value: options.city,
                              onChanged: (x) {
                                setState(() {
                                  options.city = x;
                                });
                                onSearchOptionChanged();
                                Get.back();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('all'.tr),
                                ),
                                for (String _city in Cities)
                                  DropdownMenuItem(
                                    value: _city,
                                    child: Text(_city),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                buildChoice(
                  selected: options.hobby != null,
                  text: options.hobby == null ? 'hobby'.tr : options.hobby,
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          children: [
                            Text('hobby'.tr),
                            DropdownButton<String>(
                              value: options.hobby,
                              onChanged: (x) {
                                setState(() {
                                  options.hobby = x;
                                });
                                onSearchOptionChanged();
                                Get.back();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('all'.tr),
                                ),
                                for (String _hobby in Hobbies)
                                  DropdownMenuItem(
                                    value: _hobby,
                                    child: Text(_hobby),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                buildChoice(
                  selected: options.drinking != null,
                  text: options.drinking == null
                      ? 'drinking'.tr
                      : options.drinking == 'Y'
                          ? 'drink_y'.tr
                          : 'drink_n'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          children: [
                            Text('drink'.tr),
                            DropdownButton<String>(
                              value: options.drinking,
                              onChanged: (x) {
                                setState(() {
                                  options.drinking = x;
                                });
                                onSearchOptionChanged();
                                Get.back();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('dont_select'.tr),
                                ),
                                DropdownMenuItem(
                                  value: 'Y',
                                  child: Text('drinking_y'.tr),
                                ),
                                DropdownMenuItem(
                                  value: 'N',
                                  child: Text('drinking_n'.tr),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                buildChoice(
                  selected: options.smoking != null,
                  text: options.smoking == null
                      ? 'smoking'.tr
                      : options.smoking == 'Y'
                          ? 'smoking_y'.tr
                          : 'smoking_n'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          children: [
                            Text('smoking'.tr),
                            DropdownButton<String>(
                              value: options.smoking,
                              onChanged: (x) {
                                setState(() {
                                  options.smoking = x;
                                });
                                onSearchOptionChanged();
                                Get.back();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('dont_select'.tr),
                                ),
                                DropdownMenuItem(
                                  value: 'Y',
                                  child: Text('smoking_y'.tr),
                                ),
                                DropdownMenuItem(
                                  value: 'N',
                                  child: Text('smoking_n'.tr),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                buildChoice(
                  selected: options.location != null,
                  text: options.location == null ? 'location'.tr : '${options.location} km',
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          children: [
                            Text('location'.tr),
                            DropdownButton<int>(
                              value: options.location,
                              onChanged: (x) {
                                setState(() {
                                  options.location = x;
                                });
                                onSearchOptionChanged();
                                Get.back();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('all'.tr),
                                ),
                                for (int _location in Locations)
                                  DropdownMenuItem(
                                    value: _location,
                                    child: Text('$_location km'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
