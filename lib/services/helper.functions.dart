import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// Returns a random string
///
///
String getRandomString({int len = 16, String prefix}) {
  const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
  var t = '';
  for (var i = 0; i < len; i++) {
    t += charset[(Random().nextInt(charset.length))];
  }
  if (prefix != null && prefix.isNotEmpty) t = prefix + t;
  return t;
}

/// Returns absolute file path from the relative path.
/// [path] must include the file extension.
/// @example
/// ``` dart
/// localFilePath('photo/baby.jpg');
/// ```
Future<String> getAbsoluteTemporaryFilePath(String relativePath) async {
  var directory = await getTemporaryDirectory();
  return p.join(directory.path, relativePath);
}

/// Returns filename with extension.
///
/// @example
///   `/root/users/.../abc.jpg` returns `abc.jpg`
///
String getFilenameFromPath(String path) {
  return path.split('/').last;
}

String dateTime(dynamic dt) {
  /// Server timestamp fires the event twice.
  if (dt == null) {
    return '';
  }
  DateTime time = DateTime.fromMillisecondsSinceEpoch(dt.seconds * 1000);
  return DateFormat('yyyy-MM-dd h:m:s').format(time);
}

/// Returns '9:04 PM' if it's today. Or it returns '12/30/20'.
String shortDateTime(dynamic dt) {
  /// If it's firestore `FieldValue.serverTimstamp()`, the event may be fired
  /// twice.
  if (dt == null) {
    return '';
  }
  DateTime time = DateTime.fromMillisecondsSinceEpoch(dt.seconds * 1000);
  DateTime today = DateTime.now();
  if (time.year == today.year && time.month == today.month && time.day == today.day) {
    return DateFormat.jm().format(time);
  }
  return DateFormat('dd/MM/yy').format(time);
}
