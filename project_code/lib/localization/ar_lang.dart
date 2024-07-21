import 'dart:ui';

import 'localization.dart';


class ARText implements Localization {
  @override
  TextDirection textDirection = TextDirection.rtl;

  static String getText(List<String> text) {
    String s = '';
    for (int i = text.length - 1; i >= 0; i--) {
      s = s + text[i];
    }
    return s;
  }

  // App
  @override
  String? appDescription =
      'لعبة خمن الموضع هي تطبيق يهدف إلى أن يجتمع الناس ويتواصلوا مع بعضهم البعض.';

  @override
  String? appTitle = 'موضوع الغامض';

  // Authentication
  @override
  String? email = 'البريد الاكتروني';

  @override
  String? pleaseCheckYourEmail = 'الرجاء التحقق من البريد الاكتروني الخاص بك';

  @override
  String? pleaseEnterYourEmail = 'الرجاء إدخال البريد الإلكتروني الخاص بك';

  @override
  String? pleaseEnterValidEmail = 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String? emailAlreadyExist = 'البريد الإلكتروني موجود بالفعل';

  @override
  String? emailNotValid = 'البريد الإلكتروني غير صالح';

  @override
  String? passwordLengthError = 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String? passwordNotValid = 'كلمة المرور غير صالحة';

  @override
  String? pleaseEnterYourPassword = 'الرجاء إدخال كلمة المرور';

  @override
  String? logOut = 'تسجيل الخروج';

  @override
  String? login = 'تسجيل الدخول';

  @override
  String? password = 'كلمة المرور';

  @override
  String? register = 'يسجل';

  @override
  String? registerText = 'ليس لديك حساب بعد؟';

  @override
  String? userName = 'اسم االمستخدم';

  @override
  String? userNotFound = 'لم يتم العثور على المستخدم';

  @override
  String? loginText = 'هل لديك حساب؟';

  // App Language Titles
  @override
  Map<String, String>? languageTitles = {
    'en': 'اللغة إنجليزية',
    'tr': 'اللغة التركية',
    'ar': 'اللغة العربية',
  };

  // App Language Dialog
  @override
  String? languageDialogDescription =
      'اضغط على زر اللغة المطلوبة لتغيير لغة التطبيق';

  // Internet Dialog
  @override
  String? noInternetWarningDialogText =
      'لم يتم الكشف عن اتصال بالإنترنت في هذا الوقت. تحتاج اللعبة إلى اتصال بالإنترنت لتحديث بيانات اللعبة باستمرار. يرجى إعادة الاتصال للمتابعة';

  @override
  String? languageDialogDoneButtonText = 'تم';

  // App Messages
  @override
  String? alreadyExistMessage = 'الحساب موجود بالفعل';

  @override
  String? loginMessage = 'الحساب موجود بالفعل';

  @override
  String? registerMessage = 'لقد سجلت دخول بنجاح';

  @override
  String? wrongPasswordMessage =
      'لقد أدخلت معلومات خاطئة ، يرجى التحقق مرة أخرى';

  @override
  String? signOutMessage = 'تم تسجيل الخروج بنجاح';

  @override
  String? signOutErrorMessage = 'خطأ في تسجيل الخروج';

  @override
  String? categoryExistMessage = 'الفئة موجودة';

  @override
  String? categoryNotExistMessage = 'الفئة غير موجودة';

  @override
  String? topicExistMessage = 'الموضوع موجود';

  @override
  String? topicNotExistMessage = 'الموضوع غير موجود';

  @override
  String? allCategoriesErrorMessage = 'حدث خطأ!';


  @override
  String? addCategoryToDatabaseSuccessMessage = 'تم إضافة فئة جديدة بنجاح!';

  @override
  String? addCategoryToDatabaseErrorMessage = 'حدث خطأ أثناء إضافة فئة جديدة!';

  @override
  String? addTopicToDatabaseSuccessMessage = 'تمت إضافة المواضيع بنجاح!';

  @override
  String? addTopicToDatabaseErrorMessage =
      'حدث خطأ أثناء إضافة مواضيع إلى قاعدة البيانات!';

  @override
  String? addPlayerStartGameErrorMessage =
      "يجب على اللاعبين أولاً ملء جميع مدخلات الأسماء الفارغة و"
      "تحقق مما إذا كانت هناك مشكلة في الأسماء الموجودة في القائمة";

  @override
  String? largeWebViewError =
      "هذا الجهاز لا يدعم اللعبه. يرجى لعب اللعبة فقط على متصفح هاتفك المحمول.";

  //Main Menu

  @override
  String? homePageTitle = 'القائمة الرئيسية';

  @override
  String? adminPanelText = 'لوحة الادارة';

  @override
  String? randomCategoryButtonText = 'فئة عشوائية';

  @override
  String? showAllCategoriesButtonText = 'إظهار كافة الفئات';

  //Admin Panel
  @override
  String? enterCategory = 'أدخل اسم الفئة';

  @override
  String? enterTopic = 'أدخل اسم الموضوع';

  @override
  String? addNewCategory = 'أضفه كفئة جديدة';

  @override
  String? topicAlreadyExistErrorMessage =
      '!هذا الموضوع موجود بالفعل في قاعدة البيانات';

  @override
  String? topicAlreadyExistInAddedErrorMessage = '!هذه الموضوع موجود بالفعل';

  //Bottom Sheet
  @override
  String? account = 'حساب المستخدم';

  @override
  String? theme = 'وضع الالوان';

  @override
  String? dark = 'الوضع اليلي';

  @override
  String? light = 'الوضع الضوء';

  @override
  String? system = 'كالنظام';

  @override
  String? language = 'الغة';

  @override
  String? done = 'اغلاق';

  //Add Player


  // Voting Dialog
  @override
  String? explanationText =
      'يجب على جميع اللاعبين التصويت لإنهاء اللعبة ورؤية النتيجة.';

  @override
  String? votingDialogCancelButtonText = 'إلغاء';

  @override
  String? votingDialogResetButtonText = 'إعادة ضبط';

  @override
  String? votingDialogSubmitButtonText = 'سلم';

  @override
  String? votingDialogCallButtonText = 'تصويت';

  @override
  String? returnToGame = "Return to Game";

  @override
  String? voteAgain = "Vote Again";

  @override
  String? votingStalemateText =
      "يبدو أنكم لم تقررو الشخص المخفي. لذلك، إما الاستمرار في اللعب أو التصويت مرة أخرى.";



  // Exit Dialog
  @override
  String? exitDialogCancelButtonText = 'لا';

  @override
  String? exitDialogExitButtonText = 'نعم';

  @override
  String? exitDialogDescriptionText = 'هل أنت متأكد أنك تريد الخروج من اللعبة؟';

  // Logout Dialog
  @override
  String? logoutDialogDescriptionText = 'هل انت متأكد انك تريد تسجيل الخروج';

  @override
  String? logoutDialogCancelButtonText = 'إلغاء';

  @override
  String? logoutDialogLogoutButtonText = 'تسجيل الخروج';

  //Other Stuff

  @override
  String? add = 'إضافة';

  @override
  String? close = 'أغلاق';

  @override
  String? exist = 'خروج';

  @override
  String? getAll = 'Get All';

  @override
  String? next = 'التالي';

  @override
  String? previous = 'السابق';

  @override
  String? reLoad = 'إعادة التحميل';

  @override
  String? start = 'إبدأ';

  @override
  String? vote = 'تصويت';

  @override
  String? category = 'فئة';

  @override
  String? topic = 'موضوع';

  @override
  String? show = 'إظهار';


  @override
  String? skip = 'تخطى';

  @override
  String? applicationColor = 'لون اللعبة';

  @override
  String? pleaseEnterYourPhoneNumber = '';

  // phone number in arabic language =
  @override
  String? phoneNumber = 'رقم الهاتف';

  @override
  String? page = 'صفحة';

  @override
  String? pageNotFound = 'الصفحة غير موجودة';

  @override
  String? continueText = 'إستمر';

  @override
  String? phoneNumberShouldBe10Digits = 'يجب أن يكون رقم الهاتف متكون من 10 أرقام';

  @override
  String? phoneNumberShouldStartWith5 = 'يجب أن يبدأ رقم الهاتف بـ5';

  @override
  String? examplePhoneNumber = 'مثال: 53X 8XX 2X X9';

  @override
  String? phoneNumberValidationMessage = 'رقم الهاتف الخاص بك غير صالح';

  @override
  String? nameIsEmpty = 'مكان الاسم فارغ';

  @override
  String? pleaseEnterYourName = 'الرجاء إدخال اسمك';

  @override
  String? nameShouldNotContainNumbers = 'الرجاء إدخال اسمك فقط دون أي أرقام';

  @override
  String? somethingWentWrong = 'حدث خطأ ما';

  @override
  String? welcome = 'مرحبا';

  @override
  String? group = 'مجموعة';

  @override
  String? groupIsFull = 'المجموعة ممتلئة';

  @override
  String? groupIsNotFull = 'المجموعة غير ممتلئة';

  @override
  String? groupIsNotStated  = 'المجموعة لم تبدأ بعد';

  @override
  String? groupIsStarted = 'المجموعة بدأت';

  @override
  String? groupName = 'اسم المجموعة';

  @override
  String? groupNameIsEmpty = 'اسم المجموعة فارغ';

  @override
  String? groups = 'المجموعات';

  @override
  String? pleaseEnterYourGroupName = 'الرجاء إدخال اسم مجموعتك';

  @override
  String? pleaseJoinAGroupYouNeedToPressOnJoinButton  = 'الرجاء الانضمام إلى مجموعة عن طريق الضغط على زر الانضمام';

  @override
  String? theGroupIsAvailable = 'المجموعة متاحة';

  @override
  String? theGroupIsNotAvailable = 'المجموعة غير متاحة';

  @override
  String Function({required int count})? thereIsStillXPlaceInTheGroupToStart = ({required count}) => ' لبدء المجموعة لا يزال هناك $count مكان ';

  @override
  String Function({required int count})? xPersonAreInTheGroup = ({required count}) => ' $count شخص في المجموعة ';

  @override
  String? youCanJoinTheGroupByPressingOnThePlusButton = 'يمكنك الانضمام إلى المجموعة عن طريق الضغط على زر الزائد';

  @override
  String? youDoNotHaveGroupYet = 'ليس لديك مجموعة بعد';

  @override
  String? myGroups = 'مجموعاتي';

  @override
  String? addGroup = 'إضافة مجموعة جديدة';

  @override
  String? joinGroup = 'انضمام إلى المجموعة';

  @override
  String Function({required String hatimName})? theCurrentHatimIsX = ({required hatimName}) => 'الختم الحالي هو $hatimName';

  @override
  String Function({required String week})? thisIsTheWeekXOfTheHatim = ({required week}) => 'هذا هو الأسبوع $week من الختم';

  @override
  String? newText = 'جديد';

  @override
  String? youCanFollowYourHatimAndUpdateItFromHere = 'يمكنك متابعة ختمك وتحديثه من هنا';

  @override
  String? join = 'انضم';

  @override
  String? areYouSureThatYouCompletedTheHatim = 'هل أنت متأكد من أنك أكملت الختم؟';

  @override
  String? didYouCompleteTheHatim = 'هل أكملت الختم؟';

  @override
  String? hatim = 'جزء';

  @override
  String? hatimChapter = 'جزء ';

  @override
  String? hatimChapterNumber = 'رقم الجزء';

  @override
  String? ifYouCompleteTheHatimYouNeedToPressOnTheHatimToUpdateYourHatimRound = 'إذا أكملت الجزء ، يجب عليك الضغط على الختم لتحديث جولة الختم الخاصة بك';

  @override
  String? myHatimsOfThisGroup = 'ختمتي في هذه المجموعة';

  @override
  String? no = 'لا';

  @override
  String? theCurrentHatimIsAboutToOverPleaseUpdateYourHatim = 'الختم الحالي على وشك الانتهاء ، يرجى تحديث ختمك';

  @override
  String? theHatimIsCompleted = 'الختم مكتمل';

  @override
  String? theHatimIsCompletedSuccessfully = 'تم إكمال الختم بنجاح';

  @override
  String? theHatimIsNotCompleted = 'الختم غير مكتمل';

  @override
  String? thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup = 'لا توجد مجموعات متاحة للانضمام إليها الآن. يجب عليك التحدث إلى المسؤول لإضافة مجموعة جديدة';

  @override
  String? thisHatimIsCompleted = 'هذا الختم مكتمل';

  @override
  String? thisHatimIsNotCompleted = 'هذا الختم غير مكتمل';

  @override
  String? thisIsYourCurrentHatims = 'هذه هي ختماتك الحالية';

  @override
  String? yes = 'نعم';

  @override
  String? youNeedToCompleteThisHatimToBeAbleToGoToTheNextHatim = 'يجب عليك إكمال هذا الختم لتتمكن من الانتقال إلى الختم التالي';

  @override
  String? theGroupIsNotActiveYetPleaseWaitUntilTheAppMembersJoin = 'المجموعة ليست نشطة بعد. يرجى الانتظار حتى ينضم جميع الاعضاء ';

  @override
  String? groupStatus = 'حالة المجموعة';

  @override
  String? theHatimIsOverAtThatDate = 'الختم ينتهي في ذلك التاريخ';

  @override
  String? theHatimWillStartAtThatDate = 'الختم سيبدأ في ذلك التاريخ';

  @override
  String Function({required String hatim, required int chapter})? youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter = ({required hatim, required chapter}) => 'أنت الآن في الختم $hatim وتحتاج إلى قراءة هذا الفصل $chapter';

  @override
  String? youNeedToCompleteTheHatimBeforeThatDate = 'يجب عليك إكمال الختم قبل ذلك التاريخ';

  @override
  String Function({required int chapter})? didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound = ({required chapter}) => 'هل قرأت الفصل $chapter؟ إذا كانت الإجابة نعم ، فاضغط على نعم لتحديث جولة الختم الخاصة بك';

  @override
  String? myCurrentHatim = 'ختمي الحالي';

  @override
  String Function({required String group})? youCanFollowAllTheUsersHatimsOfThatXGroupFromHere = ({required group}) => 'يمكنك متابعة جميع ختمات المستخدمين في تلك المجموعة $group من هنا';

  @override
  String? hatimEndDate = 'تاريخ نهاية الختم';

  @override
  String? hatimWillEndAt = 'سينتهي الختم في';

  @override
  String? toSeeMoreDetailsAboutTheHatimPressOnTheHatim = 'لرؤية المزيد من التفاصيل حول الختم ، اضغط على الختم';

  @override
  String? week = 'اسبوع';

}
