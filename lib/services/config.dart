class Config {
  static const appName = String.fromEnvironment('APP_NAME', defaultValue: 'App name missing');
  static const device = String.fromEnvironment('DEVICE', defaultValue: '');
  static const os = String.fromEnvironment('OS', defaultValue: '');
  static const v3Url = String.fromEnvironment('v3Url', defaultValue: null);

  static String get backendSiteUrl {
<<<<<<< HEAD
    if (v3Url != null) return v3Url;
    return 'https://api.nalia.kr/v3';
=======
    if (kReleaseMode) {
      return 'https://api.nalia.kr/v3';
    } else {
      if (device == 'simulator') {
        // return 'http://192.168.0.5/wordpress/v3';
        return 'https://local.nalia.kr/v3';
      } else {
        return 'http://192.168.0.23/wordpress/v3'; // Mr. MackBook
        // return 'http://192.168.0.5/wordpress/v3'; // Mr Song. iMac.
        // return 'http://192.168.100.17/wordpress55/v3'; // charles
        // return 'http://192.168.100.6/wordpress/v3'; // Ace
      }
    }
>>>>>>> 57b0a9a80c4c8ed76b0157ea81c0ca71ecbe7380
  }

  static final String passCallbackUrl =
      "https://id.passlogin.com/oauth2/authorize?client_id=gvC47PHoY7kS3DfpGfff&redirect_uri=https%3A%2F%2Fapi.nalia.kr%2Fv3%2Fvar%2Fpass%2Fpass_login_callback.php&response_type=code&state=apple_banana_cherry&isHybrid=Y";

  static final String galleryCategory = 'gallery';
}

String apiUrl = Config.backendSiteUrl + '/index.php';
