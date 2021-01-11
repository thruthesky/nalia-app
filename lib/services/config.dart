class Config {
  static const appName =
      String.fromEnvironment('APP_NAME', defaultValue: 'App name missing');
  static const device = String.fromEnvironment('DEVICE', defaultValue: '');
  static const os = String.fromEnvironment('OS', defaultValue: '');
}

String v3Url = 'http://192.168.0.5/wordpress/v3/index.php';

// String get v3Url => Config.device == 'device'
//     ? 'https://api.nalia.kr/v3/index.php'
//     : 'https://local.nalia.kr/v3/index.php';

final passCallbackUrl =
    "https://id.passlogin.com/oauth2/authorize?client_id=gvC47PHoY7kS3DfpGfff&redirect_uri=https%3A%2F%2Fapi.nalia.kr%2Fv3%2Fvar%2Fpass%2Fpass_login_callback.php&response_type=code&state=apple_banana_cherry&isHybrid=Y";
