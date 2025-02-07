

import 'dart:ui';

import 'localization.dart';

class TRText implements Localization {
  @override
  TextDirection textDirection = TextDirection.ltr;

  // App
  @override
  String? appDescription =
      'Bu program hatim takip çizelgesidir. ';

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
  String? emailAlreadyExist =  'Bu e-posta zaten mevcuttur';

  @override
  String? emailNotValid = 'E-posta geçerli değildir';

  @override
  String? passwordLengthError = 'Şifre en az 6 karakter olmalıdır';

  @override
  String? passwordNotValid = 'Şifre geçerli değildir';

  @override
  String? pleaseEnterYourPassword = 'Lütfen şifrenizi giriniz';

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
  String? pleaseEnterYourPhoneNumber = 'Lütfen telefon numarası ile giriş yapınız. ';

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
  String? nameShouldNotContainNumbers = 'Lütfen sadece isminizi giriniz, rakam içermemelidir';

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
  String? groupName = 'Grup numarası';

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
  String Function({required String hatimName})? theCurrentHatimIsX =
      ({required hatimName}) => 'Mevcut hatim $hatimName';

  @override
  String Function({required String week})? thisIsTheWeekXOfTheHatim =
      ({required week}) => 'Bu, Hatim\'in $week. haftasıdır';

  @override
  String? newText  = 'Yeni';

  @override
  String? youCanFollowYourHatimAndUpdateItFromHere = 'Hatminizi burdan takip edebilir ve güncelleyebilirsiniz';

  @override
  String? join = 'Katıl';

  @override
  String? areYouSureThatYouCompletedTheHatim = 'Bu haftaki hatmin cüzünü tamamladığınıza emin misiniz?';

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
  String? thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup =
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
  String Function({required String hatim, required int chapter})? youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter =
      ({required hatim, required chapter}) =>
          'Bu $hatim. hatim haftasıdır ve bu hafta $chapter. cüzü okumanız gerekmektedir';


  @override
  String? youNeedToCompleteTheHatimBeforeThatDate =
      'Haftalık hatim cüzünüzü aşağıda yer alan tarihten önce tamamlamanız gerekmektedir';

  @override
  String Function({required int chapter})? didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound =
      ({required chapter}) =>
          '$chapter. cüzü okudunuz mu? Eğer evet ise, Hatim\'inizi güncellemek için Evet\'e basınız';

  @override
  String? myCurrentHatim = 'Bu hafta kaldığım cüz';

  @override
  String Function({required String group})? youCanFollowAllTheUsersHatimsOfThatXGroupFromHere =
      ({required group}) => '$group grubundaki tüm kullanıcıların Hatimlerini buradan takip edebilirsiniz';

  @override
  String? hatimEndDate = 'Hatim bitiş tarihi';

  @override
  String? hatimWillEndAt = 'Hatim şu tarihte sona başlayacak';

  @override
  String? toSeeMoreDetailsAboutTheHatimPressOnTheHatim =
      'Hatim hakkında daha fazla ayrıntı görmek için Hatim\'e basınız';

  @override
  String? week = 'Hafta';
}
