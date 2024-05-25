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

  TextDirection _langDirection = TextDirection.ltr;

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

  get getAppLang => languageBox.get('langCode', defaultValue: 'tr');

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

  /// new group text
  String newGroupText(bool isAdmin) {
    //"${lang.newText} ${lang.joinGroup!}"
    // lang.addGroup
    // Yeni Grup Ekle ,

    if (isAdmin == false) {
      return "${getLanguage().newText} ${getLanguage().joinGroup!}";
    } else {
      return "${getLanguage().newText} ${getLanguage().addGroup!}";
    }
  }

  String groupSubtitleText({required bool isGroupActive, required int number}) {
    ///'
    ///${lang.groupStatus}: ${group.status == GroupStatus.active
    /// ? isAdmin
    ///  ? lang.theCurrentHatimIsX!(hatimName: group.getCurrentHatim().toString())
    ///  : lang.thisIsTheWeekXOfTheHatim!(week: group.getCurrentHatimOfUser(userID).toString())
    ///  : lang.groupIsNotStated!}',

    String text = "${getLanguage().groupStatus}: ";
    if (isGroupActive) {
        text += getLanguage().thisIsTheWeekXOfTheHatim!(week: number.toString());
    } else {
      text += getLanguage().groupIsNotStated!;
    }
    return text;
  }
}
