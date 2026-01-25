import 'dart:ui';

import 'localization.dart';

class ARText implements Localization {
  @override
  TextDirection textDirection = TextDirection.rtl;

  // App name
  @override
  String? appTitle = 'الامة';
  @override
  String? appDescription =
      '(وَاعْتَصِمُوا بِحَبْلِ اللَّهِ جَمِيعًا)';

  // App Language Titles
  @override
  Map<String, String>? languageTitles = {
    'en': 'English',
    'tr': 'Turkish',
    'ar': 'Arabic',
  };

  // App Language Dialog
  @override
  String? languageDialogDescription =
      'Press the desired language button to change the app\'s language';
  @override
  String? languageDialogDoneButtonText = 'Done';

  // Internet Dialog
  @override
  String? noInternetWarningDialogText =
      'No internet connection detected at this time. The app needs an internet connection to constantly update your app data. Please reconnect to continue.';

  // App Messages
  @override
  String? loginMessage = 'لقد دخلت بنجاح.';
  @override
  String? registerMessage = 'تم التسجيل بنجاح.';
  @override
  String? alreadyExistMessage = 'الحساب موجود بالفعل.';
  @override
  String? wrongPasswordMessage =
      'لقد أدخلت كلمة مرور خاطئة، يرجى المحاولة مرة أخرى.';
  @override
  String? signOutMessage = 'تم تسجيل الخروج بنجاح.';
  @override
  String? signOutErrorMessage = 'خطأ في تسجيل الخروج.';
  @override
  String? addCategoryToDatabaseSuccessMessage =
      'تمت إضافة فئة جديدة بنجاح!';
  @override
  String? addCategoryToDatabaseErrorMessage =
      'حدث خطأ أثناء إضافة فئة جديدة.';
  @override
  String? addTopicToDatabaseErrorMessage =
      'حدث خطأ أثناء إضافة المواضيع إلى قاعدة البيانات.';
  @override
  String? addTopicToDatabaseSuccessMessage = 'تمت إضافة المواضيع بنجاح!';
  @override
  String? addPlayerStartGameErrorMessage =
      'يجب على اللاعبين ملء جميع حقول الأسماء قبل البدء.';

  // Auth
  @override
  String? login = 'دخول';
  @override
  String? register = 'تسجيل';
  @override
  String? logOut = 'تسجيل الخروج';
  @override
  String? email = 'البريد الإلكتروني';
  @override
  String? pleaseCheckYourEmail = 'يرجى التحقق من بريدك الإلكتروني';
  @override
  String? pleaseEnterYourEmail = 'يرجى إدخال بريدك الإلكتروني';
  @override
  String? pleaseEnterValidEmail = 'يرجى إدخال بريد إلكتروني صحيح';
  @override
  String? emailAlreadyExist = 'البريد الإلكتروني موجود بالفعل';
  @override
  String? emailNotValid = 'البريد الإلكتروني غير صحيح';
  @override
  String? userName = 'اسم المستخدم';
  @override
  String? password = 'كلمة المرور';
  @override
  String? pleaseEnterYourPassword = 'يرجى إدخال كلمة المرور';
  @override
  String? passwordLengthError = 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
  @override
  String? passwordNotValid = 'يجب أن تحتوي كلمة المرور على رقم';
  @override
  String? adminPasswordPrompt = 'يرجى إدخال كلمة مرور المسؤول.';
  @override
  String? adminPasswordRequired = 'كلمة مرور المسؤول مطلوبة.';
  @override
  String? adminPasswordIncorrect = 'كلمة مرور المسؤول غير صحيحة.';
  @override
  String? registerText = 'لا تملك حساباً؟';
  @override
  String? loginText = 'هل لديك حساب بالفعل؟';
  @override
  String? userNotFound = 'لم يتم العثور على المستخدم.';

  // Home Page
  @override
  String? homePageTitle = 'القائمة الرئيسية';
  @override
  String? add = 'إضافة';
  @override
  String? categoryExistMessage = 'الفئة موجودة';
  @override
  String? categoryNotExistMessage = 'الفئة غير موجودة';
  @override
  String? close = 'إغلاق';
  @override
  String? enterCategory = 'أدخل اسم الفئة';
  @override
  String? enterTopic = 'أدخل اسم الموضوع';
  @override
  String? exist = 'موجود';
  @override
  String? getAll = 'الحصول على الكل';
  @override
  String? next = 'التالي';
  @override
  String? previous = 'السابق';
  @override
  String? reLoad = 'إعادة تحميل';
  @override
  String? start = 'ابدأ';
  @override
  String? topicExistMessage = 'الموضوع موجود';
  @override
  String? topicNotExistMessage = 'الموضوع غير موجود';
  @override
  String? vote = 'تصويت';
  @override
  String? category = 'الفئة';
  @override
  String? topic = 'الموضوع';
  @override
  String? adminPanelText = 'لوحة المسؤول';
  @override
  String? randomCategoryButtonText = 'فئة عشوائية';
  @override
  String? showAllCategoriesButtonText = 'عرض جميع الفئات';
  @override
  String? allCategoriesErrorMessage = 'حدث خطأ!';
  @override
  String? account = 'الحساب';
  @override
  String? theme = 'المظهر';
  @override
  String? settings = 'الإعدادات';
  @override
  String? system = 'النظام';
  @override
  String? light = 'فاتح';
  @override
  String? dark = 'داكن';
  @override
  String? language = 'اللغة';
  @override
  String? done = 'تم';

  // Admin
  @override
  String? addNewCategory = 'إضافة فئة جديدة';
  @override
  String? topicAlreadyExistErrorMessage =
      'هذا الموضوع موجود بالفعل في قاعدة البيانات.';
  @override
  String? topicAlreadyExistInAddedErrorMessage =
      'هذا الموضوع موجود بالفعل في القائمة.';

  // Voting Dialog
  @override
  String? explanationText = 'يرجى اختيار من تعتقد أنه خارج الموضوع.';
  @override
  String? votingDialogCancelButtonText = 'إلغاء';
  @override
  String? votingDialogResetButtonText = 'إعادة تعيين';
  @override
  String? votingDialogSubmitButtonText = 'إرسال';
  @override
  String? votingDialogCallButtonText = 'التصويت';
  @override
  String? votingStalemateText =
      'يبدو أنك لم تتمكن من تحديد الشخص المخفي بعد، إما أن تستمر أو تصوت مرة أخرى.';
  @override
  String? voteAgain = 'صوت مرة أخرى';
  @override
  String? returnToGame = 'العودة إلى التطبيق';

  // Exit Dialog
  @override
  String? exitDialogCancelButtonText = 'لا';
  @override
  String? exitDialogExitButtonText = 'نعم';
  @override
  String? exitDialogDescriptionText =
      'هل تريد بالتأكيد الخروج من التطبيق؟';

  // Logout Dialog
  @override
  String? logoutDialogDescriptionText =
      'هل تريد بالتأكيد تسجيل الخروج؟';
  @override
  String? logoutDialogCancelButtonText = 'إلغاء';
  @override
  String? logoutDialogLogoutButtonText = 'تسجيل الخروج';

  // Other Stuff
  @override
  String? largeWebViewError =
      'هذا الجهاز غير مدعوم. يرجى استخدام التطبيق على متصفحات الهاتف المحمول فقط.';
  @override
  String? largeWebViewNotSupportedForAccount =
      'هذه الشاشة غير مدعومة لحسابك.';
  @override
  String? show = 'عرض';
  @override
  String? skip = 'تخطي';
  @override
  String? applicationColor = 'لون التطبيق';
  @override
  String? themeMode = 'وضع المظهر';
  @override
  String? themeModeSystem = 'النظام';
  @override
  String? themeModeLightMode = 'الوضع الفاتح';
  @override
  String? themelModeDarkMode = 'الوضع الداكن';
  @override
  String? pleaseEnterYourPhoneNumber = 'يرجى إدخال رقم هاتفك';
  @override
  String? phoneNumber = 'رقم الهاتف';
  @override
  String? page = 'الصفحة';
  @override
  String? pageNotFound = 'الصفحة غير موجودة';
  @override
  String? continueText = 'متابعة';
  @override
  String? phoneNumberShouldBe10Digits = 'رقم الهاتف يجب أن يكون 10 أرقام';
  @override
  String? phoneNumberShouldStartWith5 = 'رقم الهاتف يجب أن يبدأ برقم 5';
  @override
  String? examplePhoneNumber = 'مثال: 53X 8XX 2X X9';
  @override
  String? phoneNumberValidationMessage = 'رقم هاتفك غير صحيح';
  @override
  String? pleaseEnterYourName = 'يرجى إدخال اسمك';
  @override
  String? nameIsEmpty = 'الاسم فارغ';
  @override
  String? nameShouldNotContainNumbers =
      'يرجى إدخال اسمك فقط بدون أرقام';
  @override
  String? somethingWentWrong = 'حدث خطأ ما';
  @override
  String? welcome = 'مرحبا';

  // Additional UI strings
  @override
  String? version = 'الإصدار';
  @override
  String? error = 'خطأ';
  @override
  String? errorPrefix = 'خطأ';
  @override
  String? noData = 'لا توجد بيانات';
  @override
  String? unknown = 'غير معروف';
  @override
  String? back = 'رجوع';

  // Navigation Bar
  @override
  String? zikirTab = 'الذكر';
  @override
  String? programsTab = 'البرامج';
  @override
  String? comingSoon = 'قريباً';

  // Communities
  @override
  String? communitiesTitle = 'المجتمعات';
  @override
  String? communitiesProgramsTab = 'البرامج';
  @override
  String? communitiesMembersTab = 'الأعضاء';
  @override
  String? communitiesJoinRequestsTab = 'طلبات الانضمام';
  @override
  String? communitiesSettingsTab = 'الإعدادات';

  @override
  String? communitiesNameLabel = 'الاسم';
  @override
  String? communitiesNameRequired = 'الاسم مطلوب';
  @override
  String? communitiesNameTooShort = 'الاسم قصير جداً';
  @override
  String? communitiesDescriptionLabel = 'الوصف';
  @override
  String? communitiesDescriptionRequired = 'الوصف مطلوب';

  @override
  String? communitiesJoinButton = 'انضمام';
  @override
  String? communitiesJoinTitle = 'انضمام للمجتمع';
  @override
  String? communitiesJoinDescription = 'هل تريد الانضمام إلى {name}؟';
  @override
  String? communitiesJoinRequested = 'تم إرسال طلب الانضمام';
  @override
  String? communitiesMemberChip = 'عضو';
  @override
  String? communitiesPendingChip = 'قيد الانتظار';

  @override
  String? communitiesEnterInviteCode = 'أدخل رمز الدعوة';
  @override
  String? communitiesInviteCodeLabel = 'الرمز';
  @override
  String? communitiesInviteCodeRequired = 'الرمز مطلوب';
  @override
  String? communitiesInviteCodeInvalid = 'رمز غير صحيح';
  @override
  String? communitiesInviteRedeemFailed = 'رمز غير صحيح أو منتهي الصلاحية';
  @override
  String? communitiesInviteRedeemSuccess = 'تم الانضمام للمجتمع';

  @override
  String? communitiesEmptyTitle = 'لا توجد مجتمعات بعد';
  @override
  String? communitiesEmptyDescription = 'ستظهر المجتمعات هنا.';
  @override
  String? communitiesMembersOnlyMessage = 'انضم إلى هذا المجتمع لعرض البرامج.';
  @override
  String? communitiesNoProgramsTitle = 'لا توجد برامج بعد';

  @override
  String? communitiesNoJoinRequests = 'لا توجد طلبات معلقة';
  @override
  String? communitiesJoinRequestPending = 'قيد الانتظار';
  @override
  String? communitiesApprove = 'موافقة';
  @override
  String? communitiesReject = 'رفض';
  @override
  String? communitiesMyTitle = 'مجتمعاتي';
  @override
  String? communitiesMyEmpty = 'لم تنضم إلى أي مجتمعات بعد.';
  @override
  String? communitiesExploreButton = 'استكشف';

  // Super Admin
  @override
  String? superAdminPanelTitle = 'مسؤول سوبر';
  @override
  String? superAdminPanelDescription = 'إدارة المجتمعات';
  @override
  String? superAdminRequiresLargeScreen = 'لوحة المسؤول السوبر تتطلب جهاز لوحي/سطح مكتب.';
  @override
  String? superAdminManage = 'إدارة';

  @override
  String? superAdminCreateCommunityTitle = 'إنشاء مجتمع';
  @override
  String? superAdminEditCommunityTitle = 'تحرير المجتمع';
  @override
  String? superAdminCreate = 'إنشاء';
  @override
  String? superAdminCommunityCreated = 'تم إنشاء المجتمع';
  @override
  String? superAdminCommunityUpdated = 'تم تحديث المجتمع';

  @override
  String? superAdminArchiveTitle = 'أرشفة المجتمع';
  @override
  String? superAdminArchiveDescription = 'أرشفة {name}؟';
  @override
  String? superAdminArchive = 'أرشفة';
  @override
  String? superAdminCommunityArchived = 'تم أرشفة المجتمع';
  @override
  String? superAdminActiveChip = 'نشط';
  @override
  String? superAdminArchivedChip = 'مؤرشف';

  // Profile Page - Statistics & Support
  @override
  String? statistics = 'الإحصائيات';
  @override
  String? score = 'النقاط';
  @override
  String? completedChapters = 'الفصول المكتملة';
  @override
  String? security = 'الأمان';
  @override
  String? changePassword = 'تغيير كلمة المرور';
  @override
  String? setPassword = 'تعيين كلمة المرور';
  @override
  String? updatePasswordDescription =
      'حدث كلمة مرور تسجيل الدخول الخاصة بك';
  @override
  String? setPasswordDescription =
      'أضف حماية بكلمة مرور إلى حسابك';
  @override
  String? passwordResetNote =
      'ملاحظة: إذا نسيت كلمة المرور الخاصة بك، اتصل بالدعم لإعادة تعيينها.';
  @override
  String? support = 'الدعم';
  @override
  String? supportContact = 'جهات الاتصال بالدعم';
  @override
  String? whatsAppSupport = 'دعم واتس آب';
  @override
  String? chatWithUs = 'تحدث معنا';
  @override
  String? callSupportError = 'لا يمكن بدء مكالمة هاتفية';
  @override
  String? whatsAppSupportError = 'لا يمكن فتح واتس آب';
  @override
  String? callSupport = 'اتصل بالدعم';
}
