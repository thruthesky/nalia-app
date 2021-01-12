import 'package:flutter/foundation.dart';

class Config {
  static const appName = String.fromEnvironment('APP_NAME', defaultValue: 'App name missing');
  static const device = String.fromEnvironment('DEVICE', defaultValue: '');
  static const os = String.fromEnvironment('OS', defaultValue: '');

  static String get backendSiteUrl {
    if (kReleaseMode) {
      return 'https://api.nalia.kr/v3';
    } else {
      if (device == 'simulator') {
        // return 'http://192.168.0.5/wordpress/v3';
        return 'https://local.nalia.kr/v3';
      } else {
        return 'http://192.168.0.5/wordpress/v3';
      }
    }
  }

  static final String passCallbackUrl =
      "https://id.passlogin.com/oauth2/authorize?client_id=gvC47PHoY7kS3DfpGfff&redirect_uri=https%3A%2F%2Fapi.nalia.kr%2Fv3%2Fvar%2Fpass%2Fpass_login_callback.php&response_type=code&state=apple_banana_cherry&isHybrid=Y";
}

String v3Url = Config.backendSiteUrl + '/index.php';

// String v3Url = 'http://192.168.100.17/wordpress55/v3/index.php'; // Charles
