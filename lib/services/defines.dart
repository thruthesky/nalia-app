import 'package:flutter/material.dart';

const String PRIMARY_PHOTO = 'primaryPhoto';
const String LIST_ORDER = 'listOrder';
const String USER_PHOTO_GALLERY = 'user-photo-gallery';

const String TO_UID_CREDIT_DOC_NOT_EXISTS = 'TO_UID_CREDIT_DOC_NOT_EXISTS';
const String NOT_ENOUGH_JEWELRY = 'NOT_ENOUGH_JEWELRY';

const String ERROR_NOT_ENOUGH_JEWELRY = 'ERROR_NOT_ENOUGH_JEWELRY';
const String ERROR_PROFILE_READY = 'ERROR_PROFILE_READY';
const String ERROR_PROFILE_INCOMPLETE = 'ERROR_PROFILE_INCOMPLETE';

const String ERROR_IMAGE_NOT_SELECTED = 'ERROR_IMAGE_NOT_SELECTED';
const String ERROR_LOGIN_FIRST = 'ERROR_LOGIN_FIRST';
const String ERROR_EMPTY_TOKENS = 'ERROR_EMPTY_TOKENS';

const String JEWELRY = 'jewelry';
const String DIAMOND = 'diamond';
const String GOLD = 'gold';
const String SILVER = 'silver';

const String BAG = 'bag';
const String WATCH = 'watch';
const String RING = 'ring';

const double HEADER_HEIGHT = 44.0;

const List<int> HeightGroups = [
  145,
  150,
  155,
  160,
  165,
  170,
  175,
  180,
  185,
  190,
  195,
  200,
  205,
  210,
];
const List<int> WeightGroups = [
  45,
  50,
  55,
  60,
  65,
  70,
  75,
  80,
  85,
  90,
  95,
  100,
  110,
  120,
];

const List<String> Cities = [
  'Seoul',
  'Busan',
  'Manila',
  'Angeles',
  'Tokyo',
  'Beijing',
  'Los Angeles',
  'Califonia',
];
const List<String> Hobbies = ['Reading Books', 'Movies', 'Music', 'Sports', 'Piano', 'Dancing'];
const List<String> DateMethods = [
  'Watching movies',
  'Walking',
  'Drinking coffee',
  'Travel',
  'Watching a play',
  'Eating'
];

const List<int> Locations = [1, 5, 10, 20, 30, 50, 100];

final hintStyle = TextStyle(fontSize: 12, color: Colors.grey);
final titleStyle = TextStyle(fontSize: 24, color: Colors.grey[900]);

const double xxs = 4;
const double xs = 8;
const double xsm = 12;
const double sm = 16;
const double md = 24;
const double lg = 32;
const double xl = 40;
const double xxl = 56;

final spaceXxs = SizedBox(width: xxs, height: xxs);
final spaceXs = SizedBox(width: xs, height: xs);
final spaceSm = SizedBox(width: sm, height: sm);
final spaceMd = SizedBox(width: md, height: md);
final spaceLg = SizedBox(width: lg, height: lg);
final spaceXl = SizedBox(width: xl, height: xl);
final spaceXxl = SizedBox(width: xxl, height: xxl);

final pagePadding = EdgeInsets.all(16);

final Color kBackgroundColor = Colors.amber[50];
final Color kPrimaryColor = Colors.blueGrey;
