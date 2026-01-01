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
  String? adminPasswordPrompt = 'الرجاء إدخال كلمة مرور المسؤول للمتابعة';

  @override
  String? adminPasswordRequired = 'كلمة مرور المسؤول مطلوبة';

  @override
  String? adminPasswordIncorrect =
      'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';

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
      'لم يتم الكشف عن اتصال بالإنترنت في هذا الوقت. يحتاج التطبيق إلى اتصال بالإنترنت لتحديث بيانات التطبيق باستمرار. يرجى إعادة الاتصال للمتابعة';

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
      "هذا الجهاز لا يدعم التطبيق. يرجى استخدام التطبيق فقط على متصفح هاتفك المحمول.";

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
  String? settings = 'الإعدادات';

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
  String? returnToGame = "العودة إلى التطبيق";

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
  String? exitDialogDescriptionText =
      'هل أنت متأكد أنك تريد الخروج من التطبيق؟';

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
  String? applicationColor = 'لون التطبيق';

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
  String? phoneNumberShouldBe10Digits =
      'يجب أن يكون رقم الهاتف متكون من 10 أرقام';

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
  String? groupIsNotStated = 'المجموعة لم تبدأ بعد';

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
  String? pleaseJoinAGroupYouNeedToPressOnJoinButton =
      'الرجاء الانضمام إلى مجموعة عن طريق الضغط على زر الانضمام';

  @override
  String? theGroupIsAvailable = 'المجموعة متاحة';

  @override
  String? theGroupIsNotAvailable = 'المجموعة غير متاحة';

  @override
  String Function({required int count})? thereIsStillXPlaceInTheGroupToStart =
      ({required count}) => ' لبدء المجموعة لا يزال هناك $count مكان ';

  @override
  String Function({required int count})? xPersonAreInTheGroup =
      ({required count}) => ' $count شخص في المجموعة ';

  @override
  String? youCanJoinTheGroupByPressingOnThePlusButton =
      'يمكنك الانضمام إلى المجموعة عن طريق الضغط على زر الزائد';

  @override
  String? youDoNotHaveGroupYet = 'ليس لديك مجموعة بعد';

  @override
  String? myGroups = 'مجموعاتي';

  @override
  String? addGroup = 'إضافة مجموعة جديدة';

  @override
  String? joinGroup = 'انضمام إلى المجموعة';

  @override
  String? myCreatedGroups = 'المجموعات التي أنشأتها';

  @override
  String Function({required String hatimName})? theCurrentHatimIsX =
      ({required hatimName}) => 'الختم الحالي هو $hatimName';

  @override
  String Function({required String week})? thisIsTheWeekXOfTheHatim =
      ({required week}) => 'هذا هو الأسبوع $week من الختم';

  @override
  String? newText = 'جديد';

  @override
  String? youCanFollowYourHatimAndUpdateItFromHere =
      'يمكنك متابعة ختمك وتحديثه من هنا';

  @override
  String? join = 'انضم';

  @override
  String? areYouSureThatYouCompletedTheHatim =
      'هل أنت متأكد من أنك أكملت الختم؟';

  @override
  String? didYouCompleteTheHatim = 'هل أكملت الختم؟';

  @override
  String? hatim = 'جزء';

  @override
  String? hatimChapter = 'جزء ';

  @override
  String? hatimChapterNumber = 'رقم الجزء';

  @override
  String? ifYouCompleteTheHatimYouNeedToPressOnTheHatimToUpdateYourHatimRound =
      'إذا أكملت الجزء ، يجب عليك الضغط على الختم لتحديث جولة الختم الخاصة بك';

  @override
  String? myHatimsOfThisGroup = 'ختمتي في هذه المجموعة';

  @override
  String? no = 'لا';

  @override
  String? theCurrentHatimIsAboutToOverPleaseUpdateYourHatim =
      'الختم الحالي على وشك الانتهاء ، يرجى تحديث ختمك';

  @override
  String? theHatimIsCompleted = 'الختم مكتمل';

  @override
  String? theHatimIsCompletedSuccessfully = 'تم إكمال الختم بنجاح';

  @override
  String? theHatimIsNotCompleted = 'الختم غير مكتمل';

  @override
  String?
  thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup =
      'لا توجد مجموعات متاحة للانضمام إليها الآن. يجب عليك التحدث إلى المسؤول لإضافة مجموعة جديدة';

  @override
  String? thisHatimIsCompleted = 'هذا الختم مكتمل';

  @override
  String? thisHatimIsNotCompleted = 'هذا الختم غير مكتمل';

  @override
  String? thisIsYourCurrentHatims = 'هذه هي ختماتك الحالية';

  @override
  String? yes = 'نعم';

  @override
  String? youNeedToCompleteThisHatimToBeAbleToGoToTheNextHatim =
      'يجب عليك إكمال هذا الختم لتتمكن من الانتقال إلى الختم التالي';

  @override
  String? theGroupIsNotActiveYetPleaseWaitUntilTheAppMembersJoin =
      'المجموعة ليست نشطة بعد. يرجى الانتظار حتى ينضم جميع الاعضاء ';

  @override
  String? groupStatus = 'حالة المجموعة';

  @override
  String? theHatimIsOverAtThatDate = 'الختم ينتهي في ذلك التاريخ';

  @override
  String? theHatimWillStartAtThatDate = 'الختم سيبدأ في ذلك التاريخ';

  @override
  String Function({required String hatim, required int chapter})?
  youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter =
      ({required hatim, required chapter}) =>
          'أنت الآن في الختم $hatim وتحتاج إلى قراءة هذا الفصل $chapter';

  @override
  String? youNeedToCompleteTheHatimBeforeThatDate =
      'يجب عليك إكمال الختم قبل ذلك التاريخ';

  @override
  String Function({required int chapter})?
  didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound =
      ({required chapter}) =>
          'هل قرأت الفصل $chapter؟ إذا كانت الإجابة نعم ، فاضغط على نعم لتحديث جولة الختم الخاصة بك';

  @override
  String? myCurrentHatim = 'ختمي الحالي';

  @override
  String Function({required String group})?
  youCanFollowAllTheUsersHatimsOfThatXGroupFromHere = ({required group}) =>
      'يمكنك متابعة جميع ختمات المستخدمين في تلك المجموعة $group من هنا';

  @override
  String? hatimEndDate = 'تاريخ نهاية الختم';

  @override
  String? hatimWillEndAt = 'سينتهي الختم في';

  @override
  String? toSeeMoreDetailsAboutTheHatimPressOnTheHatim =
      'لرؤية المزيد من التفاصيل حول الختم ، اضغط على الختم';

  @override
  String? week = 'اسبوع';

  @override
  String? version = 'الإصدار';

  @override
  String? error = 'خطأ';

  @override
  String? errorPrefix = 'خطأ: ';

  @override
  String? noData = 'لا توجد بيانات';

  @override
  String? unknown = 'غير معروف';

  @override
  String? back = 'رجوع';

  @override
  String? hatimDetails = 'تفاصيل الختم';

  @override
  String? errorLoadingUserData = 'خطأ في تحميل بيانات المستخدم: ';

  @override
  String? errorHatimRoundNull = 'خطأ: جولة الختم فارغة';

  @override
  String? groupCountDefault = 'عدد المجموعة الافتراضي: 30';

  @override
  String? pleaseEnterValidNumber = 'الرجاء إدخال رقم صالح';

  @override
  String? pleaseEnterNumberLessThan100 = 'الرجاء إدخال رقم أقل من 100';

  @override
  String? addWithRandomID = 'إضافة برقم عشوائي';

  @override
  String? groupNameAlreadyExists =
      'اسم المجموعة موجود بالفعل، يرجى إنشاء واحد جديد';

  @override
  String? groupNameHelperText = 'سيتم عرض هذا الاسم للمستخدمين';

  @override
  String? groupIDLabel = 'معرف المجموعة';

  @override
  String? groupIDHelperText = 'المعرف الرقمي الفريد للمجموعة';

  @override
  String? groupIDMustBe6Digits =
      'يجب أن يكون معرف المجموعة مكوناً من 6 أرقام بالضبط';

  @override
  String? groupIDMustContainOnlyNumbers =
      'يجب أن يحتوي معرف المجموعة على أرقام فقط';

  @override
  String? groupDateTypeLabel = 'نوع تاريخ المجموعة';

  @override
  String? hatimStyleLabel = 'نمط الحتم';

  @override
  String? hatimStyleAllTogetherInOneHatim = 'الكل معاً في ختم واحد';

  @override
  String? hatimStyleByRounds = 'ختم بالاجزاء';

  @override
  String? hatimStyleByChallenge = 'حسب التحدي';

  @override
  String? hatimStyleAllTogetherInOneHatimDescription =
      'جميع أعضاء المجموعة يقرؤون نفس الختم معاً. يجب أن تحتوي المجموعة على 30 عضواً بالضبط.';

  @override
  String? hatimStyleByRoundsDescription =
      'أعضاء المجموعة يقرؤون الختم في جولات. كل جولة لها توزيع مختلف.';

  @override
  String? hatimStyleByChallengeDescription =
      'أعضاء المجموعة يقرؤون الختم في شكل تحدٍ. يوفر توزيعاً أكثر مرونة.';

  @override
  String? failedToGenerateRandomID = 'فشل في إنشاء معرف عشوائي';

  @override
  String? failedToCreateGroup = 'فشل في إنشاء المجموعة';

  @override
  String? unexpectedErrorOccurred = 'حدث خطأ غير متوقع';

  @override
  String? allTogetherInOneHatimMustBe30 =
      'يجب أن يحتوي "الكل معاً في ختم واحد" على 30 شخصاً بالضبط';

  @override
  String? allTogetherInOneHatimMustBe30Description =
      'بالنسبة لنمط "الكل معاً في ختم واحد"، يجب أن تحتوي المجموعة على 30 عضواً بالضبط. يرجى تعيين العدد إلى 30.';

  @override
  String? otherStylesCanBeFlexible =
      'الأنماط الأخرى يمكن أن يكون لها عدد أعضاء مرن (1-100)';

  @override
  String? deleteGroup = 'حذف المجموعة';

  @override
  String? deleteGroupConfirmation = 'هل أنت متأكد أنك تريد حذف هذه المجموعة';

  @override
  String? deleteButton = 'حذف';

  @override
  String? groupDeletedSuccessfully = 'تم حذف المجموعة بنجاح';

  @override
  String? userRemovedSuccessfully = 'تمت إزالة المستخدم بنجاح';

  @override
  String? youAreNotAnAdmin = 'أنت لست مسؤولاً';

  @override
  String? youHaveNotCreatedAnyGroupsYet = 'لم تقم بإنشاء أي مجموعات بعد';

  @override
  String? statusLabel = 'الحالة:';

  @override
  String? usersLabel = 'المستخدمون:';

  @override
  String? adminDashboard = 'لوحة تحكم المسؤول';

  @override
  String? preferences = 'التفضيلات';

  @override
  String? appearance = 'المظهر';

  @override
  String? hatimTab = 'ختمة';

  @override
  String? zikirTab = 'ذكر';

  @override
  String? programsTab = 'برامج';

  @override
  String? profileTab = 'الملف الشخصي';

  @override
  String? myHatimProgramTab = 'برنامج ختمتي';

  @override
  String? myZikirTab = 'أذكاري';

  @override
  String? myProgramsTab = 'برامجي';

  @override
  String? myUsersTab = 'مستخدميني';

  @override
  String? groupDetailsSection = 'تفاصيل المجموعة';

  @override
  String? groupIdentificationSection = 'معرف المجموعة';

  @override
  String? hatimConfigurationSection = 'إعدادات الختم';

  @override
  String? durationTypeHelperText =
      'اختر المدة التي يجب على الأعضاء إكمال أجزائهم فيها';

  @override
  String? groupDateTypeWeek = 'أسبوع';

  @override
  String? groupDateTypeDay = 'يوم';

  @override
  String? referenceCode = 'رمز الاحالة';

  @override
  String? referenceCodeHint = 'أدخل رمز الاحالة';

  @override
  String? referenceCodeOptional = 'رمز الاحالة (اختياري)';

  @override
  String? referredUsers = 'المستخدمون المحالون';

  @override
  String? generateReferenceCode = 'إنشاء رمز الاحالة';

  @override
  String? selectUsersToAdd = 'اختر المستخدمين للإضافة';

  @override
  String? noReferredUsersFound = 'لم يتم العثور على مستخدمين محالين';

  @override
  String? userAlreadyInGroup = 'المستخدم موجود بالفعل في المجموعة';

  @override
  String? deleteCode = 'حذف الرمز';

  @override
  String? areYouSureYouWantToDeleteThisCode =
      'هل أنت متأكد أنك تريد حذف هذا الرمز؟';

  @override
  String? cancel = 'إلغاء';

  @override
  String? delete = 'حذف';

  @override
  String? remove = 'إزالة';

  @override
  String? removeUserFromReferrals = 'إزالة من الإحالات';

  @override
  String? areYouSureYouWantToRemoveThisUserFromYourReferrals =
      'هل أنت متأكد أنك تريد إزالة هذا المستخدم من إحالاتك؟';

  @override
  String? get createReferenceCode => 'إنشاء رمز الاحالة';

  @override
  String? get customCode => 'رمز مخصص';

  @override
  String? get randomCode => 'رمز عشوائي';

  @override
  String? get enterCustomCode => 'أدخل رمزاً مخصصاً';

  @override
  String? get codeAlreadyExists => 'هذا الرمز موجود بالفعل';

  @override
  String? get referenceCodeCreatedSuccessfully => 'تم إنشاء رمز الاحالة بنجاح';

  // App Info Dialog
  @override
  String? get infoButtonTooltip => 'معلومات التطبيق';

  @override
  String? get appInfoTitle => 'معلومات التطبيق';

  @override
  String? get aboutAppTitle => 'عن التطبيق';

  @override
  String? get aboutAppDescription =>
      'هذا التطبيق يساعدك على تنظيم وتتبع برامج الختم بكفاءة.';

  @override
  String? get whyWeMadeAppTitle => 'لماذا صنعنا هذا التطبيق';

  @override
  String? get whyWeMadeAppDescription =>
      'لتسهيل تنسيق دوائر قراءة القرآن وجعل الأمر أسهل للمجموعات لإكمال الختمات معاً.';

  @override
  String? get supporterCommunitiesTitle => 'المجتمعات الداعمة';

  @override
  String? get supporterCommunitiesList =>
      '1. زوجتي\n2. Yavuz Selim Vakıf İstanbul';

  @override
  String? get contactSupportTitle => 'تواصل للدعم';

  @override
  String? get contactSupportDescription =>
      'إذا كنت ترغب في الدعم، يمكنك التواصل مع:';

  @override
  String? get supportPhoneNumber => '+905551234567';

  @override
  String? get comingSoon => 'قريباً';

  // Profile Page - Statistics & Support
  @override
  String? get statistics => 'الإحصائيات';
  @override
  String? get score => 'النقاط';
  @override
  String? get completedHatims => 'الختمات المكتملة';
  @override
  String? get completedChapters => 'الأجزاء المكتملة';
  @override
  String? get security => 'الأمان';
  @override
  String? get changePassword => 'تغيير كلمة المرور';
  @override
  String? get setPassword => 'تعيين كلمة المرور';
  @override
  String? get updatePasswordDescription => 'تحديث كلمة مرور تسجيل الدخول';
  @override
  String? get setPasswordDescription => 'إضافة حماية بكلمة مرور لحسابك';
  @override
  String? get passwordResetNote =>
      'ملاحظة: إذا نسيت كلمة المرور، اتصل بالدعم على +095388902129 لإعادة تعيينها.';
  @override
  String? get support => 'الدعم';
  @override
  String? get supportContact => 'اتصل بالدعم';
  @override
  String? get whatsAppSupport => 'دعم واتساب';
  @override
  String? get chatWithUs => 'دردش معنا';
  @override
  String? get callSupportError => 'لا يمكن إجراء المكالمة إلى';
  @override
  String? get whatsAppSupportError => 'لا يمكن فتح واتساب';
  @override
  String? get callSupport => 'اتصل للدعم';
  @override
  String get whoMadeThisAppDescription => 'هذا التطبيق تم تطويره من قبل محمد السعيد و روضة نور ارمغان السعيد .';
  
  @override
  String get whoMadeThisAppTitle => 'من صنع هذا التطبيق';

  // Admin Group Details Page
  @override
  String? get editLabel => 'تعديل';
  @override
  String? get roundsLabel => 'الجولات';
  @override
  String? get cannotReduceUserCountBelowCurrentMembers => 
      'لا يمكن تقليل الحد الأقصى للأعضاء عن عدد الأعضاء الحاليين';
  @override
  String? get groupUpdatedSuccessfully => 'تم تحديث المجموعة بنجاح';
  @override
  String? get calendarTypeLabel => 'نوع التقويم';
  @override
  String? get immutableLabel => 'لا يمكن تغييره';
  @override
  String? get startDateTimeSection => 'تاريخ ووقت البدء';
  @override
  String? get configurationSection => 'الإعدادات';
  @override
  String? get maxMembersLabel => 'الحد الأقصى للأعضاء';
  @override
  String? get currentMembersLabel => 'الحالي';
  @override
  String? get minimumLabel => 'الحد الأدنى';
  @override
  String? get roundCountLabel => 'عدد الجولات';
  @override
  String? get saveChanges => 'حفظ التغييرات';
  @override
  String? get removeUserTitle => 'إزالة المستخدم';
  @override
  String? get removeUserConfirmation => 
      'هل أنت متأكد أنك تريد إزالة هذا المستخدم من المجموعة؟';
  @override
  String? get removeButton => 'إزالة';
  @override
  String? get noUsersInGroup => 'لا يوجد مستخدمون في هذه المجموعة بعد';
  @override
  String? get removeUser => 'إزالة المستخدم';
  @override
  String? get noRoundsYet => 'لا توجد جولات بعد';
  @override
  String? get roundsWillAppearWhenGroupActive => 
      'ستظهر الجولات عندما تصبح المجموعة نشطة';
  @override
  String? get roundLabel => 'الجولة';
  @override
  String? get completedLabel => 'مكتمل';
  @override
  String? get pendingLabel => 'قيد الانتظار';
  @override
  String? get totalLabel => 'المجموع';
  @override
  String? get juzLabel => 'جزء';
  @override
  String? get membersLabel => 'الأعضاء';

  // Calendar Types
  @override
  String? get hijriCalendar => 'هجري (إسلامي)';
  @override
  String? get gregorianCalendar => 'ميلادي';
  @override
  String? get calendarTypeHelperText => 
      'اختر نظام التقويم لهذه المجموعة. لا يمكن تغييره لاحقاً.';
  @override
  String? get startDateLabel => 'تاريخ البدء (اختياري)';
  @override
  String? get startDateHelperText => 
      'متى يجب أن يبدأ الختم. اتركه فارغاً للبدء عند اكتمال المجموعة.';
  @override
  String? get startTimeLabel => 'وقت البدء (اختياري)';
  @override
  String? get gregorianEquivalent => 'المعادل الميلادي';
  @override
  String? get hijriEquivalent => 'المعادل الهجري';
  @override
  String? get selectDate => 'اختر التاريخ';
  @override
  String? get selectHijriDate => 'اختر التاريخ الهجري';
  @override
  String? get selectTime => 'اختر الوقت';
  @override
  String? get pleaseSelectDurationType => 'يرجى اختيار نوع المدة';

  // Hijri Date Picker
  @override
  String? get hijriDateLabel => 'التاريخ الهجري';
  @override
  String? get gregorianDateLabel => 'التاريخ الميلادي';
  @override
  String? get dayLabel => 'اليوم';
  @override
  String? get monthLabel => 'الشهر';
  @override
  String? get yearLabel => 'السنة';
  @override
  String? get timeLabel => 'الوقت';
  @override
  String? get dualCalendarDisplay => 'عرض التاريخ';

  // Round Details
  @override
  String? get endDateLabel => 'تاريخ الانتهاء';
  @override
  String? get roundDurationLabel => 'مدة الجولة';
}
