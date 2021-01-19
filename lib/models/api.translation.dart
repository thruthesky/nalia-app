import 'package:get/get.dart';
import 'package:nalia_app/services/global.dart';

/// Default translated texts.
///
/// This will be available immediately after app boots before downloading the
/// translations from Backend. You can add some default translations here.
///
/// After updating(getting translations from backend), newly translated texts
/// like `'..code..'.tr` will work. But if there is translations that are already
/// rendered on screen, the app needs to re-render ( by setState method or any other means )
Map<String, Map<String, String>> translations = {
  "en": {
    "app-name": "Nalia",
    "home": "Home",
  },
  "ko": {
    "app-name": "나리야",
    "home": "홈",
  }
};

/// Update translation document data from Firestore into `GetX locale format`.
updateTranslations(Map<dynamic, dynamic> data) {
  data.forEach((ln, texts) {
    for (var name in texts.keys) {
      translations[ln][name] = texts[name];
    }
  });
}

/// GetX locale text translations.
class AppTranslations extends Translations {
  AppTranslations() {
    print('AppTranslations()');
    api.translationList().then(updateTranslations);
  }
  updateTranslations(data) {
    for (String ln in data['translations'].keys) {
      for (String code in data['translations'][ln].keys) {
        String value = data['translations'][ln][code];
        if (translations[ln] == null) translations[ln] = {};
        translations[ln][code] = value;
      }
    }
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
