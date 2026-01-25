import 'dart:ui';

import 'package:hatim_program/core/localization/lang/localization.dart';



class TRText implements Localization {
  @override
  TextDirection textDirection = TextDirection.ltr;

  // App name
  @override
  String? appTitle = 'YAVUZ SELİM VAKFI HATİM ÇİZELGE TAKİP FORMU';
  @override
  String? appDescription =
      'Konu Tahmin Uygulaması, insanların bir araya gelerek sosyal iletişim kurmasını amaçlayan bir uygulamadır.';

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
  String? loginMessage = 'Başarıyla giriş yaptınız.';
  @override
  String? registerMessage = 'Kayıt başarılı.';
  @override
  String? alreadyExistMessage = 'Hesap zaten var.';
  @override
  String? wrongPasswordMessage =
      'Yanlış şifre girdiniz, lütfen tekrar deneyin.';
  @override
  String? signOutMessage = 'Başarıyla çıkış yaptınız.';
  @override
  String? signOutErrorMessage = 'Çıkış yapılırken hata oluştu.';
  @override
  String? addCategoryToDatabaseSuccessMessage =
      'Yeni kategori başarıyla eklendi!';
  @override
  String? addCategoryToDatabaseErrorMessage =
      'Yeni kategori eklenirken hata oluştu.';
  @override
  String? addTopicToDatabaseErrorMessage =
      'Konular veritabanına eklenirken hata oluştu.';
  @override
  String? addTopicToDatabaseSuccessMessage = 'Konular başarıyla eklendi!';
  @override
  String? addPlayerStartGameErrorMessage =
      'Oyuncuların başlamadan önce tüm ad alanlarını doldurması gerekir.';

  // Auth
  @override
  String? login = 'Giriş';
  @override
  String? register = 'Kayıt';
  @override
  String? logOut = 'Çıkış';
  @override
  String? email = 'E-posta';
  @override
  String? pleaseCheckYourEmail = 'Lütfen e-postanızı kontrol edin';
  @override
  String? pleaseEnterYourEmail = 'Lütfen e-postanızı girin';
  @override
  String? pleaseEnterValidEmail = 'Lütfen geçerli bir e-posta girin';
  @override
  String? emailAlreadyExist = 'E-posta zaten var';
  @override
  String? emailNotValid = 'E-posta geçerli değil';
  @override
  String? userName = 'Kullanıcı Adı';
  @override
  String? password = 'Şifre';
  @override
  String? pleaseEnterYourPassword = 'Lütfen şifrenizi girin';
  @override
  String? passwordLengthError = 'Şifre en az 6 karakter olmalıdır';
  @override
  String? passwordNotValid = 'Şifre bir numara içermeli';
  @override
  String? adminPasswordPrompt = 'Lütfen yönetici şifrenizi girin.';
  @override
  String? adminPasswordRequired = 'Yönetici şifresi gereklidir.';
  @override
  String? adminPasswordIncorrect = 'Yönetici şifresi yanlış.';
  @override
  String? registerText = 'Henüz hesabınız yok mu?';
  @override
  String? loginText = 'Zaten bir hesabınız var mı?';
  @override
  String? userNotFound = 'Kullanıcı bulunamadı.';

  // Home Page
  @override
  String? homePageTitle = 'Ana Menü';
  @override
  String? add = 'Ekle';
  @override
  String? categoryExistMessage = 'Kategori var';
  @override
  String? categoryNotExistMessage = 'Kategori yok';
  @override
  String? close = 'Kapat';
  @override
  String? enterCategory = 'Kategori adı girin';
  @override
  String? enterTopic = 'Konu adı girin';
  @override
  String? exist = 'Var';
  @override
  String? getAll = 'Tümünü Al';
  @override
  String? next = 'Sonraki';
  @override
  String? previous = 'Önceki';
  @override
  String? reLoad = 'Yeniden Yükle';
  @override
  String? start = 'Başla';
  @override
  String? topicExistMessage = 'Konu var';
  @override
  String? topicNotExistMessage = 'Konu yok';
  @override
  String? vote = 'Oyla';
  @override
  String? category = 'Kategori';
  @override
  String? topic = 'Konu';
  @override
  String? adminPanelText = 'Yönetici Paneli';
  @override
  String? randomCategoryButtonText = 'Rastgele Kategori';
  @override
  String? showAllCategoriesButtonText = 'Tüm Kategorileri Göster';
  @override
  String? allCategoriesErrorMessage = 'Bir hata oluştu!';
  @override
  String? account = 'Hesap';
  @override
  String? theme = 'Tema';
  @override
  String? settings = 'Ayarlar';
  @override
  String? system = 'Sistem';
  @override
  String? light = 'Açık';
  @override
  String? dark = 'Koyu';
  @override
  String? language = 'Dil';
  @override
  String? done = 'Tamam';

  // Admin
  @override
  String? addNewCategory = 'Yeni kategori ekle';
  @override
  String? topicAlreadyExistErrorMessage =
      'Bu konu zaten veritabanında var.';
  @override
  String? topicAlreadyExistInAddedErrorMessage =
      'Bu konu zaten listede var.';

  // Voting Dialog
  @override
  String? explanationText = 'Lütfen konunun dışında olduğunu düşündüğünüz kişiyi seçin.';
  @override
  String? votingDialogCancelButtonText = 'İptal';
  @override
  String? votingDialogResetButtonText = 'Sıfırla';
  @override
  String? votingDialogSubmitButtonText = 'Gönder';
  @override
  String? votingDialogCallButtonText = 'Oylama';
  @override
  String? votingStalemateText =
      'Gizli kişiye henüz karar verememiş gibi görünüyorsunuz, devam edin veya tekrar oylayın.';
  @override
  String? voteAgain = 'Tekrar Oyla';
  @override
  String? returnToGame = 'Uygulamaya Dön';

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
      'Çıkış yapmak istediğinizden emin misiniz?';
  @override
  String? logoutDialogCancelButtonText = 'İptal';
  @override
  String? logoutDialogLogoutButtonText = 'Çıkış';

  // Other Stuff
  @override
  String? largeWebViewError =
      'Bu cihaz desteklenmiyor. Lütfen uygulamayı yalnızca mobil tarayıcılarda kullanın.';
  @override
  String? largeWebViewNotSupportedForAccount =
      'Bu ekran hesabınız için desteklenmiyor.';
  @override
  String? show = 'Göster';
  @override
  String? skip = 'Atla';
  @override
  String? applicationColor = 'Uygulama Rengi';
  @override
  String? themeMode = 'Tema Modu';
  @override
  String? themeModeSystem = 'Sistem';
  @override
  String? themeModeLightMode = 'Açık Mod';
  @override
  String? themelModeDarkMode = 'Koyu Mod';
  @override
  String? pleaseEnterYourPhoneNumber = 'Lütfen Telefon Numaranızı Girin';
  @override
  String? phoneNumber = 'Telefon Numarası';
  @override
  String? page = 'Sayfa';
  @override
  String? pageNotFound = 'Sayfa Bulunamadı';
  @override
  String? continueText = 'Devam Et';
  @override
  String? phoneNumberShouldBe10Digits = 'Telefon numarası 10 haneli olmalıdır';
  @override
  String? phoneNumberShouldStartWith5 = 'Telefon numarası 5 ile başlamalıdır';
  @override
  String? examplePhoneNumber = 'Örnek: 53X 8XX 2X X9';
  @override
  String? phoneNumberValidationMessage = 'Telefon numaranız geçerli değil';
  @override
  String? pleaseEnterYourName = 'Lütfen Adınızı Girin';
  @override
  String? nameIsEmpty = 'Ad boş';
  @override
  String? nameShouldNotContainNumbers =
      'Lütfen yalnızca adınızı boş sayılar olmadan girin';
  @override
  String? somethingWentWrong = 'Bir şeyler yanlış gitti';
  @override
  String? welcome = 'Hoş Geldiniz';

  // Additional UI strings
  @override
  String? version = 'Sürüm';
  @override
  String? error = 'Hata';
  @override
  String? errorPrefix = 'Hata';
  @override
  String? noData = 'Veri Yok';
  @override
  String? unknown = 'Bilinmiyor';
  @override
  String? back = 'Geri';

  // Navigation Bar
  @override
  String? zikirTab = 'Zikir';
  @override
  String? programsTab = 'Programlar';
  @override
  String? comingSoon = 'Yakında';

  // Communities
  @override
  String? communitiesTitle = 'Topluluklar';
  @override
  String? communitiesProgramsTab = 'Programlar';
  @override
  String? communitiesMembersTab = 'Üyeler';
  @override
  String? communitiesJoinRequestsTab = 'Katılım İstekleri';
  @override
  String? communitiesSettingsTab = 'Ayarlar';

  @override
  String? communitiesNameLabel = 'Ad';
  @override
  String? communitiesNameRequired = 'Ad gerekli';
  @override
  String? communitiesNameTooShort = 'Ad çok kısa';
  @override
  String? communitiesDescriptionLabel = 'Açıklama';
  @override
  String? communitiesDescriptionRequired = 'Açıklama gerekli';

  @override
  String? communitiesJoinButton = 'Katıl';
  @override
  String? communitiesJoinTitle = 'Topluluğa Katıl';
  @override
  String? communitiesJoinDescription = '{name} toplumluğuna katılmak istiyor musunuz?';
  @override
  String? communitiesJoinRequested = 'Katılım isteği gönderildi';
  @override
  String? communitiesMemberChip = 'Üye';
  @override
  String? communitiesPendingChip = 'Beklemede';

  @override
  String? communitiesEnterInviteCode = 'Davet kodunu girin';
  @override
  String? communitiesInviteCodeLabel = 'Kod';
  @override
  String? communitiesInviteCodeRequired = 'Kod gerekli';
  @override
  String? communitiesInviteCodeInvalid = 'Geçersiz kod';
  @override
  String? communitiesInviteRedeemFailed = 'Geçersiz veya süresi dolmuş kod';
  @override
  String? communitiesInviteRedeemSuccess = 'Topluluğa katıldı';

  @override
  String? communitiesEmptyTitle = 'Henüz topluluk yok';
  @override
  String? communitiesEmptyDescription = 'Topluluklar burada görünecek.';
  @override
  String? communitiesMembersOnlyMessage = 'Programları görüntülemek için bu topluluğa katılın.';
  @override
  String? communitiesNoProgramsTitle = 'Henüz program yok';

  @override
  String? communitiesNoJoinRequests = 'Beklemede istek yok';
  @override
  String? communitiesJoinRequestPending = 'Beklemede';
  @override
  String? communitiesApprove = 'Onayla';
  @override
  String? communitiesReject = 'Reddet';
  @override
  String? communitiesMyTitle = 'Topluluksları';
  @override
  String? communitiesMyEmpty = 'Henüz hiçbir topluluğa katılmadınız.';
  @override
  String? communitiesExploreButton = 'Keşfet';

  // Super Admin
  @override
  String? superAdminPanelTitle = 'Süper Yönetici';
  @override
  String? superAdminPanelDescription = 'Toplulukları yönet';
  @override
  String? superAdminRequiresLargeScreen = 'Süper Yönetici paneli tablet/masaüstü gerektirir.';

  @override
  String? superAdminCreateCommunityTitle = 'Topluluk oluştur';
  @override
  String? superAdminEditCommunityTitle = 'Topluluğu düzenle';
  @override
  String? superAdminCreate = 'Oluştur';
  @override
  String? superAdminCommunityCreated = 'Topluluk oluşturuldu';
  @override
  String? superAdminCommunityUpdated = 'Topluluk güncellendi';

  @override
  String? superAdminArchiveTitle = 'Topluluğu arşivle';
  @override
  String? superAdminArchiveDescription = '{name} arşivlensin mi?';
  @override
  String? superAdminArchive = 'Arşivle';
  @override
  String? superAdminCommunityArchived = 'Topluluk arşivlendi';
  @override
  String? superAdminActiveChip = 'Aktif';
  @override
  String? superAdminArchivedChip = 'Arşivlenmiş';

  // Profile Page - Statistics & Support
  @override
  String? statistics = 'İstatistikler';
  @override
  String? score = 'Puan';
  @override
  String? completedChapters = 'Tamamlanan Bölümler';
  @override
  String? security = 'Güvenlik';
  @override
  String? changePassword = 'Şifreyi Değiştir';
  @override
  String? setPassword = 'Şifre Belirle';
  @override
  String? updatePasswordDescription =
      'Giriş şifrenizi güncelleyin';
  @override
  String? setPasswordDescription =
      'Hesabınıza şifre koruması ekleyin';
  @override
  String? passwordResetNote =
      'Not: Şifrenizi unutursanız, sıfırlamak için desteğe başvurun.';
  @override
  String? support = 'Destek';
  @override
  String? supportContact = 'Destek İletişim';
  @override
  String? whatsAppSupport = 'WhatsApp Desteği';
  @override
  String? chatWithUs = 'Bizimle Sohbet Edin';
  @override
  String? callSupportError = 'Telefon araması başlatılamadı';
  @override
  String? whatsAppSupportError = 'WhatsApp açılamadı';
  @override
  String? callSupport = 'Desteği Ara';

  @override
  String? superAdminManage = 'Yönet';
}
