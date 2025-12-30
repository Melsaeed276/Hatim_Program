import 'dart:ui';

import 'localization.dart';

class TRText implements Localization {
  @override
  TextDirection textDirection = TextDirection.ltr;

  // App
  @override
  String? appDescription = 'Bu program hatim takip çizelgesidir. ';

  @override
  String? appTitle = 'YAVUZ SELİM VAKFI HATİM ÇİZELGE TAKİP FORMU';

  // Authentication
  @override
  String? email = 'E-posta';

  @override
  String? pleaseCheckYourEmail = 'Lütfen e-postanızı kontrol ediniz';

  @override
  String? pleaseEnterYourEmail = 'Lütfen e-postanızı giriniz';

  @override
  String? pleaseEnterValidEmail = 'Lütfen geçerli bir e-posta giriniz';

  @override
  String? emailAlreadyExist = 'Bu e-posta zaten mevcuttur';

  @override
  String? emailNotValid = 'E-posta geçerli değildir';

  @override
  String? passwordLengthError = 'Şifre en az 6 karakter olmalıdır';

  @override
  String? passwordNotValid = 'Şifre geçerli değildir';

  @override
  String? pleaseEnterYourPassword = 'Lütfen şifrenizi giriniz';

  @override
  String? adminPasswordPrompt = 'Devam etmek için lütfen admin şifrenizi girin';

  @override
  String? adminPasswordRequired = 'Admin şifresi gereklidir';

  @override
  String? adminPasswordIncorrect = 'Yanlış şifre. Lütfen tekrar deneyin.';

  @override
  String? logOut = 'Oturumu kapat';

  @override
  String? login = 'Giriş';

  @override
  String? password = 'Şifre';

  @override
  String? register = 'Kaydol';

  @override
  String? registerText = 'Henüz bir hesabınız yok mu?';

  @override
  String? userName = 'Kullanıcı Adı';

  @override
  String? userNotFound = 'Kullanıcı Bulunamadı';

  @override
  String? loginText = 'Zaten hesabınız var mı?';

  // App Language Titles
  @override
  Map<String, String>? languageTitles = {
    'en': 'İngilizce',
    'tr': 'Türkçe',
    'ar': 'Arapça',
  };

  // App Language Dialog
  @override
  String? languageDialogDescription =
      'Uygulamanın dilini değiştirmek için istediğiniz dil düğmesine basın';

  // Internet Dialog

  @override
  String? noInternetWarningDialogText =
      'Şu anda internet bağlantısı algılanmadı. Bu uygulama, verilerini sürekli güncellemek için internet bağlantısına ihtiyaç duyar. Devam etmek için lütfen tekrar bağlanın';

  @override
  String? languageDialogDoneButtonText = 'Bitti';

  // App Messages
  @override
  String? alreadyExistMessage = 'Hesap zaten mevcut';

  @override
  String? loginMessage = 'Giriş başarılı';

  @override
  String? registerMessage = 'Kayıt başarılı';

  @override
  String? wrongPasswordMessage =
      'Yanlış bilgi girdiniz, lütfen tekrar kontrol ediniz';

  @override
  String? signOutMessage = 'Hesaptan çıkış başarılı';

  @override
  String? signOutErrorMessage = 'Oturum kapatma hatası';

  @override
  String? categoryExistMessage = 'Kategori zaten mevcut';

  @override
  String? categoryNotExistMessage = 'Kategori mevcut değil';

  @override
  String? topicExistMessage = 'Konu zaten mevcut';

  @override
  String? topicNotExistMessage = 'Konu mevcut değil';

  @override
  String? allCategoriesErrorMessage = 'Bir hata oluştu!';

  @override
  String? addCategoryToDatabaseSuccessMessage =
      'Yeni bir kategori başarıyla eklendi!';

  @override
  String? addCategoryToDatabaseErrorMessage =
      'Yeni bir kategori eklenirken bir hata oluştu!';

  @override
  String? addTopicToDatabaseSuccessMessage = 'Konular başarıyla eklendi!';

  @override
  String? addTopicToDatabaseErrorMessage =
      'Konuların veritabanına  eklenirken bir hata oluştu!';

  @override
  String? addPlayerStartGameErrorMessage =
      'Üyeler önce tüm boş isim girişlerini doldurmalı ve'
      ' listedeki isimlerle ilgili bir sorun olup olmadığını kontrol etmelidir.';

  @override
  String? largeWebViewError =
      "Bu cihaz desteklenmiyor. Lütfen bu uygulamaya sadece mobil tarayıcıda giriniz.";

  // Main Menu
  @override
  String? homePageTitle = 'Ana Menü';

  @override
  String? adminPanelText = 'Admin Paneli';

  @override
  String? randomCategoryButtonText = 'Rastgele Kategori';

  @override
  String? showAllCategoriesButtonText = 'Tüm Kategorileri göster';

  // Admin Panel
  @override
  String? enterCategory = ' Kategori adı girin';

  @override
  String? enterTopic = ' Konu adı girin';

  @override
  String? addNewCategory = 'Yeni kategori olarak ekle';

  @override
  String? topicAlreadyExistErrorMessage = 'Bu konu veritabanında zaten var!';

  @override
  String? topicAlreadyExistInAddedErrorMessage = 'Bu konu listede zaten var!';

  //Bottom Sheet
  @override
  String? account = 'Hesap';

  @override
  String? theme = 'Tema';

  @override
  String? settings = 'Ayarlar';

  @override
  String? dark = 'karanlık';

  @override
  String? light = 'Aydınlık';

  @override
  String? system = 'Sistem';

  @override
  String? language = 'Dil';

  @override
  String? done = 'Tamamlandı';

  // Voting Dialog

  @override
  String? explanationText =
      'Lütfen konunun dışında olduğunu düşündüğünüz kişileri seçiniz.';

  @override
  String? votingDialogCancelButtonText = 'İptal';

  @override
  String? votingDialogResetButtonText = 'Sıfırla';

  @override
  String? votingDialogSubmitButtonText = 'Onayla';

  @override
  String? votingDialogCallButtonText = 'Onaylama';

  @override
  String? returnToGame = "Uygulamaya geri dön";

  @override
  String? voteAgain = "Tekrar Oy Ver";

  @override
  String? votingStalemateText =
      "Gizli kişiye karar veremediniz. Devam etmek için devam edin ya da en baştan tekrar oy verin.";

  // Exit Dialog
  @override
  String? exitDialogCancelButtonText = 'Hayır';

  @override
  String? exitDialogExitButtonText = 'Evet';

  @override
  String? exitDialogDescriptionText =
      'Uygulamadan çıkmak istediğinizden emin misiniz?';

  // Logout Dialog
  @override
  String? logoutDialogDescriptionText =
      'Oturumu kapatmak istediğinizden emin misiniz?';

  @override
  String? logoutDialogCancelButtonText = 'İptal';

  @override
  String? logoutDialogLogoutButtonText = 'Çıkış Yap';

  // Other stuff

  @override
  String? add = 'Ekle';

  @override
  String? close = 'Kapat';

  @override
  String? exist = 'Mevcut';

  @override
  String? getAll = 'Hepsini al';

  @override
  String? next = 'Sonraki';

  @override
  String? previous = 'Önceki';

  @override
  String? reLoad = 'Tekrar yükle';

  @override
  String? start = 'Başla';

  @override
  String? vote = 'Oy Ver';

  @override
  String? category = 'Kategori';

  @override
  String? topic = 'Konu';

  @override
  String? show = 'Göster';

  @override
  String? skip = 'Atla';

  @override
  String? applicationColor = 'Uygulama Rengi';

  @override
  String? pleaseEnterYourPhoneNumber =
      'Lütfen telefon numarası ile giriş yapınız. ';

  @override
  String? phoneNumber = 'Telefon numarası';

  @override
  String? page = 'Sayfa';

  @override
  String? pageNotFound = 'Sayfa bulunamadı';

  @override
  String? continueText = 'Devam et';

  @override
  String? examplePhoneNumber = 'Örnek: 53X 8XX 2X X9';

  @override
  String? phoneNumberShouldBe10Digits = 'Telefon numarası 10 haneli olmalıdır';

  @override
  String? phoneNumberShouldStartWith5 = 'Telefon numarası 5 ile başlamalıdır';

  @override
  String? phoneNumberValidationMessage = 'Telefon numaranız geçerli değil';

  @override
  String? nameIsEmpty = 'İsim yeri boş';

  @override
  String? pleaseEnterYourName = 'Lütfen isminizi giriniz';

  @override
  String? nameShouldNotContainNumbers =
      'Lütfen sadece isminizi giriniz, rakam içermemelidir';

  @override
  String? somethingWentWrong = 'Hata oluştu';

  @override
  String? welcome = 'Hoş geldiniz';

  @override
  String? group = 'Grup';

  @override
  String? groupIsFull = 'Grup dolu';

  @override
  String? groupIsNotFull = 'Grup dolu değil';

  @override
  String? groupIsNotStated = 'Grup hala başlatılmadı';

  @override
  String? groupIsStarted = 'Grup başlatıldı';

  @override
  String? groupName = 'Grup adı';

  @override
  String? groupNameIsEmpty = 'Grup adı boş';

  @override
  String? groups = 'Gruplar';

  @override
  String? pleaseEnterYourGroupName = 'Lütfen grup adınızı giriniz';

  @override
  String? pleaseJoinAGroupYouNeedToPressOnJoinButton =
      'Lütfen bir gruba katılın, katılmak için katıl düğmesine basmanız gerekmektedir';

  @override
  String? theGroupIsAvailable = 'Grup mevcut';

  @override
  String? theGroupIsNotAvailable = 'Grup mevcut değil';

  @override
  String Function({required int count})? thereIsStillXPlaceInTheGroupToStart =
      ({required count}) => 'Başlamak için grupta hala $count yer var';

  @override
  String Function({required int count})? xPersonAreInTheGroup =
      ({required count}) => '$count kişi grupta vardır';

  @override
  String? youCanJoinTheGroupByPressingOnThePlusButton =
      'Artı düğmesine basarak gruba katılabilirsiniz';

  @override
  String? youDoNotHaveGroupYet = 'Henüz bir grubunuz yoktur';

  @override
  String? myGroups = 'Gruplarım';

  @override
  String? addGroup = 'Grup Ekle';

  @override
  String? joinGroup = 'Gruba Katıl';

  @override
  String? myCreatedGroups = 'Oluşturduğum Gruplar';

  @override
  String Function({required String hatimName})? theCurrentHatimIsX =
      ({required hatimName}) => 'Mevcut hatim $hatimName';

  @override
  String Function({required String week})? thisIsTheWeekXOfTheHatim =
      ({required week}) => 'Bu, Hatim\'in $week. haftasıdır';

  @override
  String? newText = 'Yeni';

  @override
  String? youCanFollowYourHatimAndUpdateItFromHere =
      'Hatminizi burdan takip edebilir ve güncelleyebilirsiniz';

  @override
  String? join = 'Katıl';

  @override
  String? areYouSureThatYouCompletedTheHatim =
      'Bu haftaki hatmin cüzünü tamamladığınıza emin misiniz?';

  @override
  String? didYouCompleteTheHatim = 'Cüzünüzü tamamladınız mı?';

  @override
  String? hatim = 'Hatim';

  @override
  String? hatimChapter = 'Hatim cüzü';

  @override
  String? hatimChapterNumber = 'Hatim cüz numarası';

  @override
  String? ifYouCompleteTheHatimYouNeedToPressOnTheHatimToUpdateYourHatimRound =
      'Haftalık cüzünüzü tamamladığınızda cüz bilginizi güncelleyiniz.';

  @override
  String? myHatimsOfThisGroup = 'Hatim - Cüz Bilgisi';

  @override
  String? no = 'Hayır';

  @override
  String? theCurrentHatimIsAboutToOverPleaseUpdateYourHatim =
      'Mevcut Hatim bitmek üzere, lütfen Hatim\'inizi güncelleyin';

  @override
  String? theHatimIsCompleted = 'Hatim cüzü tamamlandı';

  @override
  String? theHatimIsCompletedSuccessfully = 'Hatim cüzü başarıyla tamamlandı';

  @override
  String? theHatimIsNotCompleted = 'Hatim cüzü tamamlanmadı';

  @override
  String?
  thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup =
      'Şu anda katılabileceğiniz uygun grup yok. Yeni bir grup eklemek için yöneticiyle konuşmanız gerekmektedir';

  @override
  String? thisHatimIsCompleted = 'Bu Hatim tamamlandı';

  @override
  String? thisHatimIsNotCompleted = 'Bu Hatim tamamlanmadı';

  @override
  String? thisIsYourCurrentHatims = 'Bu, mevcut Hatimlerinizdir';

  @override
  String? yes = 'Evet';

  @override
  String? youNeedToCompleteThisHatimToBeAbleToGoToTheNextHatim =
      'Bir sonraki Hatim\'e geçebilmek için şimdiki Hatim\'i tamamlamanız gerekmektedir';

  @override
  String? theGroupIsNotActiveYetPleaseWaitUntilTheAppMembersJoin =
      'Grup henüz aktif değil, lütfen grup üyeleri katılana kadar bekleyiniz';

  @override
  String? groupStatus = 'Grup durumu';

  @override
  String? theHatimIsOverAtThatDate = 'Hatim o tarihte bitmiştir';

  @override
  String? theHatimWillStartAtThatDate = 'Hatim o tarihte başlayacak';

  @override
  String Function({required String hatim, required int chapter})?
  youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter =
      ({required hatim, required chapter}) =>
          'Bu $hatim. hatim haftasıdır ve bu hafta $chapter. cüzü okumanız gerekmektedir';

  @override
  String? youNeedToCompleteTheHatimBeforeThatDate =
      'Haftalık hatim cüzünüzü aşağıda yer alan tarihten önce tamamlamanız gerekmektedir';

  @override
  String Function({required int chapter})?
  didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound =
      ({required chapter}) =>
          '$chapter. cüzü okudunuz mu? Eğer evet ise, Hatim\'inizi güncellemek için Evet\'e basınız';

  @override
  String? myCurrentHatim = 'Bu hafta kaldığım cüz';

  @override
  String Function({required String group})?
  youCanFollowAllTheUsersHatimsOfThatXGroupFromHere = ({required group}) =>
      '$group grubundaki tüm kullanıcıların Hatimlerini buradan takip edebilirsiniz';

  @override
  String? hatimEndDate = 'Hatim bitiş tarihi';

  @override
  String? hatimWillEndAt = 'Hatim şu tarihte sona başlayacak';

  @override
  String? toSeeMoreDetailsAboutTheHatimPressOnTheHatim =
      'Hatim hakkında daha fazla ayrıntı görmek için Hatim\'e basınız';

  @override
  String? week = 'Hafta';

  @override
  String? version = 'Sürüm';

  @override
  String? error = 'Hata';

  @override
  String? errorPrefix = 'Hata: ';

  @override
  String? noData = 'Veri yok';

  @override
  String? unknown = 'Bilinmiyor';

  @override
  String? back = 'Geri';

  @override
  String? hatimDetails = 'Hatim Detayları';

  @override
  String? errorLoadingUserData = 'Kullanıcı verisi yüklenirken hata: ';

  @override
  String? errorHatimRoundNull = 'Hata: Hatim Turu null';

  @override
  String? groupCountDefault = 'Grup sayısı varsayılan: 30';

  @override
  String? pleaseEnterValidNumber = 'Lütfen geçerli bir sayı giriniz';

  @override
  String? pleaseEnterNumberLessThan100 =
      'Lütfen 100\'den küçük bir sayı giriniz';

  @override
  String? addWithRandomID = 'Rastgele ID ile ekle';

  @override
  String? groupNameAlreadyExists =
      'Grup adı zaten mevcut, lütfen yeni bir tane oluşturun';

  @override
  String? groupNameHelperText = 'Bu isim kullanıcılara gösterilecek';

  @override
  String? groupIDLabel = 'Grup ID';

  @override
  String? groupIDHelperText = 'Grubun benzersiz sayısal kimliği';

  @override
  String? groupIDMustBe6Digits = 'Grup ID\'si tam olarak 6 haneli olmalıdır';

  @override
  String? groupIDMustContainOnlyNumbers =
      'Grup ID\'si sadece rakamlardan oluşmalıdır';

  @override
  String? groupDateTypeLabel = 'Grup tarih türü';

  @override
  String? hatimStyleLabel = 'Hatim stili';

  @override
  String? hatimStyleAllTogetherInOneHatim = 'Hep Birlikte Tek Hatim';

  @override
  String? hatimStyleByRounds = "Kur'an'ın bölümlerini tamamlayın.";

  @override
  String? hatimStyleByChallenge = 'Meydan Okuma Bazlı';

  @override
  String? hatimStyleAllTogetherInOneHatimDescription =
      'Tüm grup üyeleri birlikte aynı hatmi okur. Grup tam olarak 30 üyeden oluşmalıdır.';

  @override
  String? hatimStyleByRoundsDescription =
      'Grup üyeleri tur bazlı olarak hatim okur. Her turda farklı bir dağılım yapılır.';

  @override
  String? hatimStyleByChallengeDescription =
      'Grup üyeleri meydan okuma formatında hatim okur. Daha esnek bir dağılım sağlar.';

  @override
  String? failedToGenerateRandomID = 'Rastgele ID oluşturulamadı';

  @override
  String? failedToCreateGroup = 'Grup oluşturulamadı';

  @override
  String? unexpectedErrorOccurred = 'Beklenmeyen bir hata oluştu';

  @override
  String? allTogetherInOneHatimMustBe30 =
      'Hep Birlikte Tek Hatimde tam olarak 30 kişi olmalıdır';

  @override
  String? allTogetherInOneHatimMustBe30Description =
      '"Hep Birlikte Tek Hatim" stili için, grup tam olarak 30 üyeye sahip olmalıdır. Lütfen sayıyı 30 olarak ayarlayın.';

  @override
  String? otherStylesCanBeFlexible =
      'Diğer stiller esnek üye sayısına sahip olabilir (1-100)';

  @override
  String? deleteGroup = 'Grubu Sil';

  @override
  String? deleteGroupConfirmation =
      'Bu grubu silmek istediğinize emin misiniz?';

  @override
  String? deleteButton = 'Sil';

  @override
  String? groupDeletedSuccessfully = 'Grup başarıyla silindi';

  @override
  String? youAreNotAnAdmin = 'Bir yönetici değilsiniz';

  @override
  String? youHaveNotCreatedAnyGroupsYet = 'Henüz hiç grup oluşturmadınız';

  @override
  String? statusLabel = 'Durum:';

  @override
  String? usersLabel = 'Kullanıcılar:';

  @override
  String? adminDashboard = 'Yönetici Paneli';

  @override
  String? preferences = 'Tercihler';

  @override
  String? appearance = 'Görünüm';

  @override
  String? hatimTab = 'Hatim';

  @override
  String? zikirTab = 'Zikir';

  @override
  String? programsTab = 'Programlar';

  @override
  String? profileTab = 'Profil';

  @override
  String? myHatimProgramTab = 'Hatim Programım';

  @override
  String? myZikirTab = 'Zikirlerim';

  @override
  String? myProgramsTab = 'Programlarım';

  @override
  String? myUsersTab = 'Davetlilerim';

  @override
  String? groupDetailsSection = 'Grup Detayları';

  @override
  String? groupIdentificationSection = 'Grup Kimliği';

  @override
  String? hatimConfigurationSection = 'Hatim Yapılandırması';

  @override
  String? durationTypeHelperText =
      'Üyelerin bölümlerini tamamlamaları için ne kadar süreleri olduğunu seçin';

  @override
  String? groupDateTypeWeek = 'Hafta';

  @override
  String? groupDateTypeDay = 'Gün';

  @override
  String? referenceCode = 'Referans Kodu';

  @override
  String? referenceCodeHint = 'Referans kodunu girin';

  @override
  String? referenceCodeOptional = 'Referans Kodu (İsteğe bağlı)';

  @override
  String? referredUsers = 'Yönlendirilen Kullanıcılar';

  @override
  String? generateReferenceCode = 'Referans Kodu Oluştur';

  @override
  String? selectUsersToAdd = 'Eklenecek Kullanıcıları Seçin';

  @override
  String? noReferredUsersFound = 'Yönlendirilen kullanıcı bulunamadı';

  @override
  String? userAlreadyInGroup = 'Kullanıcı zaten grupta';

  @override
  String? deleteCode = 'Kodu Sil';

  @override
  String? areYouSureYouWantToDeleteThisCode =
      'Bu kodu silmek istediğinizden emin misiniz?';

  @override
  String? cancel = 'İptal';

  @override
  String? delete = 'Sil';

  @override
  String? remove = 'Kaldır';

  @override
  String? removeUserFromReferrals = 'Referanslardan Kaldır';

  @override
  String? areYouSureYouWantToRemoveThisUserFromYourReferrals =
      'Bu kullanıcıyı referanslarınızdan kaldırmak istediğinizden emin misiniz?';

  @override
  String? userRemovedSuccessfully = 'Kullanıcı başarıyla kaldırıldı';

  @override
  String? get createReferenceCode => 'Referans Kodu Oluştur';

  @override
  String? get customCode => 'Özel Kod';

  @override
  String? get randomCode => 'Rastgele Kod';

  @override
  String? get enterCustomCode => 'Özel kod girin';

  @override
  String? get codeAlreadyExists => 'Bu kod zaten mevcut';

  @override
  String? get referenceCodeCreatedSuccessfully =>
      'Referans kodu başarıyla oluşturuldu';

  // App Info Dialog
  @override
  String? get infoButtonTooltip => 'Uygulama Bilgisi';

  @override
  String? get appInfoTitle => 'Uygulama Bilgisi';

  @override
  String? get aboutAppTitle => 'Uygulama Hakkında';

  @override
  String? get aboutAppDescription =>
      'Bu uygulama, Hatim programlarını verimli bir şekilde organize etmenize ve takip etmenize yardımcı olur.';

  @override
  String? get whyWeMadeAppTitle => 'Bu uygulamayı neden yaptık';

  @override
  String? get whyWeMadeAppDescription =>
      'Kuran okuma halkalarının koordinasyonunu kolaylaştırmak ve grupların Hatimleri birlikte tamamlamasını sağlamak için.';

  @override
  String? get supporterCommunitiesTitle => 'Destekleyen Topluluklar';

  @override
  String? get supporterCommunitiesList =>
      '1. Eşim\n2. Yavuz Selim Vakıf İstanbul';

  @override
  String? get contactSupportTitle => 'Destek için İletişim';

  @override
  String? get contactSupportDescription =>
      'Destek olmak istiyorsanız, iletişime geçebilirsiniz:';

  @override
  String? get supportPhoneNumber => '+905551234567';

  @override
  String? get comingSoon => 'Çok Yakında';

  // Profile Page - Statistics & Support
  @override
  String? get statistics => 'İstatistikler';
  @override
  String? get score => 'Puan';
  @override
  String? get completedHatims => 'Tamamlanan Hatimler';
  @override
  String? get completedChapters => 'Tamamlanan Cüzler';
  @override
  String? get security => 'Güvenlik';
  @override
  String? get changePassword => 'Şifreyi Değiştir';
  @override
  String? get setPassword => 'Şifre Belirle';
  @override
  String? get updatePasswordDescription => 'Giriş şifrenizi güncelleyin';
  @override
  String? get setPasswordDescription => 'Hesabınıza şifre koruması ekleyin';
  @override
  String? get passwordResetNote =>
      'Not: Şifrenizi unutursanız sıfırlamak için +095388902129 numaralı telefondan destek ekibiyle iletişime geçin.';
  @override
  String? get support => 'Destek';
  @override
  String? get supportContact => 'Destek İletişim';
  @override
  String? get whatsAppSupport => 'WhatsApp Destek';
  @override
  String? get chatWithUs => 'Bizimle sohbet edin';
  @override
  String? get callSupportError => 'Arama başlatılamadı';
  @override
  String? get whatsAppSupportError => 'WhatsApp başlatılamadı';
  @override
  String? get callSupport => 'Destek için ara';
  
  @override
  String get whoMadeThisAppDescription => 'Bu uygulama Muhammed Elsaeed Ve Ravzanur Armağan Elsaeed tarafından geliştirilmiştir.';
  
  @override
  String get whoMadeThisAppTitle => 'Bu uygulamayı kim yaptı';
}
