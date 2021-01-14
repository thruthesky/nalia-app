import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.bio.search.model.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:get/get.dart';
import 'package:nalia_app/services/global.dart';

class UserSearchOptions extends StatelessWidget {
  UserSearchOptions({this.options, this.onSearchOptionChanged});

  final ApiBioSearch options;
  final Function onSearchOptionChanged;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          buildChoice(
            selected: options.ageFrom > 0,
            text: options.ageFrom > 0
                ? 'Age ${options.ageFrom}~${options.ageTo}'
                    .trArgs(['${options.ageFrom}', '${options.ageTo}'])
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
                              value: options.ageFrom,
                              onChanged: (x) {
                                setState(() {
                                  options.ageFrom = x;
                                  if (options.ageTo < options.ageFrom) {
                                    options.ageTo = options.ageFrom + 9;
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
                                    child: Text('ageFrom %s'.trArgs(['$i'])),
                                  ),
                              ],
                            ),
                            if (options.ageFrom > 0)
                              DropdownButton<int>(
                                value: options.ageTo,
                                onChanged: (x) {
                                  if (x < options.ageFrom) {
                                    x = options.ageFrom + 9;
                                    app.alert('ageTo is smaller than ageFrom'.tr);
                                  }
                                  setState(() {
                                    options.ageTo = x;
                                  });
                                  onSearchOptionChanged();
                                },
                                items: [
                                  for (int i = options.ageFrom + 1; i < 80; i++)
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text('ageTo %s'.trArgs(['$i'])),
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
                          options.gender = x;
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
            selected: options.heightFrom != 0,
            text: options.heightFrom != 0
                ? '${options.heightFrom}~${options.heightTo}cm'
                    .trArgs(['${options.heightFrom}', '${options.heightTo}'])
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
                              value: options.heightFrom,
                              onChanged: (x) {
                                setState(() {
                                  options.heightFrom = x;
                                  if (options.heightTo <= options.heightFrom) {
                                    options.heightTo = HeightGroups[
                                        HeightGroups.indexWhere((h) => h == options.heightFrom) +
                                            1];
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
                            if (options.heightFrom > 0)
                              DropdownButton<int>(
                                value: options.heightTo,
                                onChanged: (x) {
                                  if (x < options.heightFrom) {
                                    options.heightTo = HeightGroups[
                                        HeightGroups.indexWhere((h) => h == options.heightFrom) +
                                            1];
                                    app.alert('heightTo is smaller than heightFrom'.tr);
                                  }
                                  setState(() {
                                    options.heightTo = x;
                                  });
                                  onSearchOptionChanged();
                                },
                                items: [
                                  for (int h in HeightGroups.where((n) => n > options.heightFrom))
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
            selected: options.weightFrom != 0,
            text: options.weightFrom != 0
                ? '${options.weightFrom}~${options.weightTo}kg'
                    .trArgs(['${options.weightFrom}', '${options.weightTo}'])
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
                              value: options.weightFrom,
                              onChanged: (x) {
                                setState(() {
                                  options.weightFrom = x;
                                  if (options.weightTo <= options.weightFrom) {
                                    options.weightTo = WeightGroups[
                                        WeightGroups.indexWhere((h) => h == options.weightFrom) +
                                            1];
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
                            if (options.weightFrom > 0)
                              DropdownButton<int>(
                                value: options.weightTo,
                                onChanged: (x) {
                                  if (x < options.weightFrom) {
                                    // print('F');
                                    options.weightTo = WeightGroups[
                                        WeightGroups.indexWhere((h) => h == options.weightFrom) +
                                            1];
                                    app.alert('weightTo is smaller than weightFrom'.tr);
                                  }
                                  setState(() {
                                    options.weightTo = x;
                                  });
                                  onSearchOptionChanged();
                                },
                                items: [
                                  for (int h in WeightGroups.where((n) => n > options.weightFrom))
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
                          options.city = x;
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
                          options.hobby = x;
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
                          options.drinking = x;
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
                          options.smoking = x;
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
                          options.location = x;
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
      ),
    );
  }
}
