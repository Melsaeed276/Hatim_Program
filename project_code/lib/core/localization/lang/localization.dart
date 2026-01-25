import 'package:flutter/cupertino.dart';

abstract class Localization {
  late TextDirection textDirection;
  // App name
  late String? appTitle;
  late String? appDescription;

  // App Language Titles
  late Map<String, String>? languageTitles;

  // App Language Dialog

  late String? languageDialogDescription;
  late String? languageDialogDoneButtonText;

  // Internet Dialog

  late String? noInternetWarningDialogText;

  // App Messages
  late String? loginMessage;
  late String? registerMessage;
  late String? alreadyExistMessage;
  late String? wrongPasswordMessage;
  late String? signOutMessage;
  late String? signOutErrorMessage;
  late String? addCategoryToDatabaseSuccessMessage;
  late String? addCategoryToDatabaseErrorMessage;
  late String? addTopicToDatabaseErrorMessage;
  late String? addTopicToDatabaseSuccessMessage;
  late String? addPlayerStartGameErrorMessage;

  //Auth
  late String? login;
  late String? register;
  late String? logOut;
  late String? email;
  late String? pleaseCheckYourEmail;
  late String? pleaseEnterYourEmail;
  late String? pleaseEnterValidEmail;
  late String? emailAlreadyExist;
  late String? emailNotValid;

  late String? userName;
  late String? password;
  late String? pleaseEnterYourPassword;
  late String? passwordLengthError;
  late String? passwordNotValid;
  late String? adminPasswordPrompt;
  late String? adminPasswordRequired;
  late String? adminPasswordIncorrect;
  late String? registerText;
  late String? loginText;
  late String? userNotFound;

  // Home Page
  late String? homePageTitle;
  late String? add;
  late String? categoryExistMessage;
  late String? categoryNotExistMessage;
  late String? close;
  late String? enterCategory;
  late String? enterTopic;
  late String? exist;
  late String? getAll;
  late String? next;
  late String? previous;
  late String? reLoad;
  late String? start;
  late String? topicExistMessage;
  late String? topicNotExistMessage;
  late String? vote;
  late String? category;
  late String? topic;
  late String? adminPanelText;
  late String? randomCategoryButtonText;
  late String? showAllCategoriesButtonText;
  late String? allCategoriesErrorMessage;
  late String? account;
  late String? theme;
  late String? settings;
  late String? system;
  late String? light;
  late String? dark;
  late String? language;
  late String? done;

  //Admin
  late String? addNewCategory;
  late String? topicAlreadyExistErrorMessage;
  late String? topicAlreadyExistInAddedErrorMessage;

  // Voting Dialog
  late String? explanationText;
  late String? votingDialogCancelButtonText;
  late String? votingDialogResetButtonText;
  late String? votingDialogSubmitButtonText;
  late String? votingDialogCallButtonText;
  late String? votingStalemateText;
  late String? voteAgain;
  late String? returnToGame;

  // Exit Dialog
  late String? exitDialogCancelButtonText;
  late String? exitDialogExitButtonText;
  late String? exitDialogDescriptionText;

  // Logout Dialog
  late String? logoutDialogDescriptionText;
  late String? logoutDialogCancelButtonText;
  late String? logoutDialogLogoutButtonText;

  // game result

  late String? largeWebViewError;
  late String? largeWebViewNotSupportedForAccount;

  late String? show;

  late String? skip;

  late String? applicationColor;

  // Theme Mode
  late String? themeMode;
  late String? themeModeSystem;
  late String? themeModeLightMode;
  late String? themelModeDarkMode;

  late String? pleaseEnterYourPhoneNumber;
  late String? phoneNumber;

  late String? pageNotFound;
  late String? page;

  late String? continueText;

  //Phone number should be 10 digits
  late String? phoneNumberShouldBe10Digits;

  // Phone number should start with 5'
  late String? phoneNumberShouldStartWith5;

  late String? phoneNumberValidationMessage;

  //'Example: 53X 8XX 2X X9'
  late String? examplePhoneNumber;

  // please enter your name
  late String? pleaseEnterYourName;

  // name is empty
  late String? nameIsEmpty;

  // please enter only your name without any numbers
  late String? nameShouldNotContainNumbers;

  //Error something went wrong
  late String? somethingWentWrong;

  //welcome
  late String? welcome;

  // Additional UI strings
  late String? version;
  late String? error;
  late String? errorPrefix;
  late String? noData;
  late String? unknown;
  late String? back;

  // Navigation Bar
  late String? zikirTab;
  late String? programsTab;
  late String? comingSoon;

  // Communities
  late String? communitiesTitle;
  late String? communitiesProgramsTab;
  late String? communitiesMembersTab;
  late String? communitiesJoinRequestsTab;
  late String? communitiesSettingsTab;

  late String? communitiesNameLabel;
  late String? communitiesNameRequired;
  late String? communitiesNameTooShort;
  late String? communitiesDescriptionLabel;
  late String? communitiesDescriptionRequired;

  late String? communitiesJoinButton;
  late String? communitiesJoinTitle;
  late String? communitiesJoinDescription; // supports {name}
  late String? communitiesJoinRequested;
  late String? communitiesMemberChip;
  late String? communitiesPendingChip;

  late String? communitiesEnterInviteCode;
  late String? communitiesInviteCodeLabel;
  late String? communitiesInviteCodeRequired;
  late String? communitiesInviteCodeInvalid;
  late String? communitiesInviteRedeemFailed;
  late String? communitiesInviteRedeemSuccess;

  late String? communitiesEmptyTitle;
  late String? communitiesEmptyDescription;
  late String? communitiesMembersOnlyMessage;
  late String? communitiesNoProgramsTitle;

  late String? communitiesNoJoinRequests;
  late String? communitiesJoinRequestPending;
  late String? communitiesApprove;
  late String? communitiesReject;
  late String? communitiesMyTitle;
  late String? communitiesMyEmpty;
  late String? communitiesExploreButton;

  // Super Admin
  late String? superAdminPanelTitle;
  late String? superAdminPanelDescription;
  late String? superAdminRequiresLargeScreen;
  late String? superAdminManage;

  late String? superAdminCreateCommunityTitle;
  late String? superAdminEditCommunityTitle;
  late String? superAdminCreate;
  late String? superAdminCommunityCreated;
  late String? superAdminCommunityUpdated;

  late String? superAdminArchiveTitle;
  late String? superAdminArchiveDescription; // supports {name}
  late String? superAdminArchive;
  late String? superAdminCommunityArchived;
  late String? superAdminActiveChip;
  late String? superAdminArchivedChip;


  // Profile Page - Statistics & Support
  String? get statistics;
  String? get score;
  String? get completedChapters;
  String? get security;
  String? get changePassword;
  String? get setPassword;
  String? get updatePasswordDescription;
  String? get setPasswordDescription;
  String? get passwordResetNote;
  String? get support;
  String? get supportContact;
  String? get whatsAppSupport;
  String? get chatWithUs;
  String? get callSupportError;
  String? get whatsAppSupportError;
  String? get callSupport;

}
