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
    'Ooh': 'Ooh ...',
    "app-name": "Nalia",
    'yes': 'Yes',
    'no': 'No',
    'note': 'Notification',
    "home": "Home",
    "ERROR_NOT_ENOUGH_JEWELRY": "You don't have enought %s.",
    'diamond': 'Diamond',
    "gold": "Gold",
    'silver': 'Silver',
    'ERROR_PROFILE_READY': 'You have not fill up your profile.\nDo you want to update your profile?',
  },
  "ko": {
    'Ooh': '앗!',
    "app-name": "나리야",
    'yes': '예',
    'no': '아니오',
    'note': '알림',
    "home": "홈",
    "ERROR_NOT_ENOUGH_JEWELRY": "%s가 모자랍니다.",
    'diamond': '다이아몬드',
    "gold": "골드",
    'silver': '실버',
    'ERROR_PROFILE_READY': '프로필 정보가 올바로 입력되지 않았습니다.\n프로필을 수정하시겠습니까?',
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
    if (data != null &&
        data['translations'] != null &&
        data['translations'] is List &&
        data['translations'].length == 0) return;
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
