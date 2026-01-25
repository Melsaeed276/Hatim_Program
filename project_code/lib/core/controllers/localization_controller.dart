import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../localization/language_dialog/language_dialog.dart';
import '../localization/localization_setring.dart';




class LocalizationController with ChangeNotifier {

  final languageBox = Hive.box('language');

  final Map<String, Localization> languages = {
    'en': ENText(),
    'ar': ARText(),
    'tr': TRText(),
  };

  late TextDirection _langDirection;

  LocalizationController() {
    // Initialize text direction from the saved language
    _langDirection = getLanguage().textDirection;
  }

  TextDirection getLangDirection() {
    return _langDirection;
  }

  void _setLangDirection() {
    if (_langDirection == getLanguage().textDirection) {
    } else {
      _langDirection = getLanguage().textDirection;
    }
    notifyListeners();
  }

  dynamic get getAppLang => languageBox.get('langCode', defaultValue: 'tr');

  set setAppLang(String languageCode) {
    languageBox.put('langCode', languageCode);
    _setLangDirection();
    notifyListeners();
  }

  Map<String, String> getLanguageTitles() {
    return getLanguage().languageTitles!;
  }

  String getLanguageTitle() {
    return getLanguage().languageTitles![getAppLang]!;
  }

  Localization getLanguage() {
    return languages[getAppLang]!;
  }

  void getLanguageDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => const LanguageDialog(),
    );
  }
}
