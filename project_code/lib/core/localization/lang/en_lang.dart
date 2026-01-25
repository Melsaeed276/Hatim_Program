import 'dart:ui';

import 'localization.dart';

class ENText implements Localization {
  @override
  TextDirection textDirection = TextDirection.ltr;

  // App name
  @override
  String? appTitle = 'One Nation';
  @override
  String? appDescription =
      'Guess the Topic app is an application that aims for people to come together and socialize.';

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
  String? loginMessage = 'You have successfully entered.';
  @override
  String? registerMessage = 'Registration successful.';
  @override
  String? alreadyExistMessage = 'The account already exists.';
  @override
  String? wrongPasswordMessage =
      'You have entered the wrong password, please try again.';
  @override
  String? signOutMessage = 'Signed out successfully.';
  @override
  String? signOutErrorMessage = 'Error signing out.';
  @override
  String? addCategoryToDatabaseSuccessMessage =
      'A new category has been added successfully!';
  @override
  String? addCategoryToDatabaseErrorMessage =
      'An error occurred while adding a new category.';
  @override
  String? addTopicToDatabaseErrorMessage =
      'An error occurred while adding topics to the database.';
  @override
  String? addTopicToDatabaseSuccessMessage = 'Topics added successfully!';
  @override
  String? addPlayerStartGameErrorMessage =
      'Players must fill in all the name inputs before starting.';

  // Auth
  @override
  String? login = 'Login';
  @override
  String? register = 'Register';
  @override
  String? logOut = 'Sign Out';
  @override
  String? email = 'Email';
  @override
  String? pleaseCheckYourEmail = 'Please check your email';
  @override
  String? pleaseEnterYourEmail = 'Please enter your email';
  @override
  String? pleaseEnterValidEmail = 'Please enter a valid email';
  @override
  String? emailAlreadyExist = 'Email already exists';
  @override
  String? emailNotValid = 'Email is not valid';
  @override
  String? userName = 'User Name';
  @override
  String? password = 'Password';
  @override
  String? pleaseEnterYourPassword = 'Please enter your password';
  @override
  String? passwordLengthError = 'Password must be at least 6 characters';
  @override
  String? passwordNotValid = 'Password must include a number';
  @override
  String? adminPasswordPrompt = 'Please enter your admin password.';
  @override
  String? adminPasswordRequired = 'Admin password is required.';
  @override
  String? adminPasswordIncorrect = 'Admin password is incorrect.';
  @override
  String? registerText = 'Don\'t have an account yet?';
  @override
  String? loginText = 'Already have an account?';
  @override
  String? userNotFound = 'No user found.';

  // Home Page
  @override
  String? homePageTitle = 'Main Menu';
  @override
  String? add = 'Add';
  @override
  String? categoryExistMessage = 'Category exists';
  @override
  String? categoryNotExistMessage = 'Category does not exist';
  @override
  String? close = 'Close';
  @override
  String? enterCategory = 'Enter category name';
  @override
  String? enterTopic = 'Enter topic name';
  @override
  String? exist = 'Exist';
  @override
  String? getAll = 'Get All';
  @override
  String? next = 'Next';
  @override
  String? previous = 'Previous';
  @override
  String? reLoad = 'Reload';
  @override
  String? start = 'Start';
  @override
  String? topicExistMessage = 'Topic exists';
  @override
  String? topicNotExistMessage = 'Topic does not exist';
  @override
  String? vote = 'Vote';
  @override
  String? category = 'Category';
  @override
  String? topic = 'Topic';
  @override
  String? adminPanelText = 'Admin Panel';
  @override
  String? randomCategoryButtonText = 'Random Category';
  @override
  String? showAllCategoriesButtonText = 'Show All Categories';
  @override
  String? allCategoriesErrorMessage = 'An error occurred!';
  @override
  String? account = 'Account';
  @override
  String? theme = 'Theme';
  @override
  String? settings = 'Settings';
  @override
  String? system = 'System';
  @override
  String? light = 'Light';
  @override
  String? dark = 'Dark';
  @override
  String? language = 'Language';
  @override
  String? done = 'Done';

  // Admin
  @override
  String? addNewCategory = 'Add a new category';
  @override
  String? topicAlreadyExistErrorMessage =
      'This topic already exists in the database.';
  @override
  String? topicAlreadyExistInAddedErrorMessage =
      'This topic already exists in the list.';

  // Voting Dialog
  @override
  String? explanationText = 'Please choose who you think is out of the topic.';
  @override
  String? votingDialogCancelButtonText = 'Cancel';
  @override
  String? votingDialogResetButtonText = 'Reset';
  @override
  String? votingDialogSubmitButtonText = 'Submit';
  @override
  String? votingDialogCallButtonText = 'Voting';
  @override
  String? votingStalemateText =
      'It seems like you could not decide on the hidden person yet, either continue or vote again.';
  @override
  String? voteAgain = 'Vote Again';
  @override
  String? returnToGame = 'Return to App';

  // Exit Dialog
  @override
  String? exitDialogCancelButtonText = 'No';
  @override
  String? exitDialogExitButtonText = 'Yes';
  @override
  String? exitDialogDescriptionText =
      'Are you sure you want to exit the app?';

  // Logout Dialog
  @override
  String? logoutDialogDescriptionText =
      'Are you sure you want to log out?';
  @override
  String? logoutDialogCancelButtonText = 'Cancel';
  @override
  String? logoutDialogLogoutButtonText = 'Logout';

  // Other Stuff
  @override
  String? largeWebViewError =
      'This device is not supported. Please use the app only on mobile browsers.';
  @override
  String? largeWebViewNotSupportedForAccount =
      'This screen is not supported for your account.';
  @override
  String? show = 'Show';
  @override
  String? skip = 'Skip';
  @override
  String? applicationColor = 'App Color';
  @override
  String? themeMode = 'Theme Mode';
  @override
  String? themeModeSystem = 'System';
  @override
  String? themeModeLightMode = 'Light Mode';
  @override
  String? themelModeDarkMode = 'Dark Mode';
  @override
  String? pleaseEnterYourPhoneNumber = 'Please Enter Your Phone Number';
  @override
  String? phoneNumber = 'Phone Number';
  @override
  String? page = 'Page';
  @override
  String? pageNotFound = 'Page Not Found';
  @override
  String? continueText = 'Continue';
  @override
  String? phoneNumberShouldBe10Digits = 'Phone number should be 10 digits';
  @override
  String? phoneNumberShouldStartWith5 = 'Phone number should start with 5';
  @override
  String? examplePhoneNumber = 'Example: 53X 8XX 2X X9';
  @override
  String? phoneNumberValidationMessage = 'Your phone number is not valid';
  @override
  String? pleaseEnterYourName = 'Please Enter Your Name';
  @override
  String? nameIsEmpty = 'Name is empty';
  @override
  String? nameShouldNotContainNumbers =
      'Please enter only your name without any numbers';
  @override
  String? somethingWentWrong = 'Something went wrong';
  @override
  String? welcome = 'Welcome';

  // Additional UI strings
  @override
  String? version = 'Version';
  @override
  String? error = 'Error';
  @override
  String? errorPrefix = 'Error';
  @override
  String? noData = 'No Data';
  @override
  String? unknown = 'Unknown';
  @override
  String? back = 'Back';

  // Navigation Bar
  @override
  String? zikirTab = 'Zikir';
  @override
  String? programsTab = 'Programs';
  @override
  String? comingSoon = 'Coming Soon';

  // Communities
  @override
  String? communitiesTitle = 'Communities';
  @override
  String? communitiesProgramsTab = 'Programs';
  @override
  String? communitiesMembersTab = 'Members';
  @override
  String? communitiesJoinRequestsTab = 'Join Requests';
  @override
  String? communitiesSettingsTab = 'Settings';

  @override
  String? communitiesNameLabel = 'Name';
  @override
  String? communitiesNameRequired = 'Name is required';
  @override
  String? communitiesNameTooShort = 'Name is too short';
  @override
  String? communitiesDescriptionLabel = 'Description';
  @override
  String? communitiesDescriptionRequired = 'Description is required';

  @override
  String? communitiesJoinButton = 'Join';
  @override
  String? communitiesJoinTitle = 'Join community';
  @override
  String? communitiesJoinDescription = 'Request to join {name}?';
  @override
  String? communitiesJoinRequested = 'Join request sent';
  @override
  String? communitiesMemberChip = 'Member';
  @override
  String? communitiesPendingChip = 'Pending';

  @override
  String? communitiesEnterInviteCode = 'Enter invitation code';
  @override
  String? communitiesInviteCodeLabel = 'Code';
  @override
  String? communitiesInviteCodeRequired = 'Code is required';
  @override
  String? communitiesInviteCodeInvalid = 'Invalid code';
  @override
  String? communitiesInviteRedeemFailed = 'Invalid or expired code';
  @override
  String? communitiesInviteRedeemSuccess = 'Joined community';

  @override
  String? communitiesEmptyTitle = 'No communities yet';
  @override
  String? communitiesEmptyDescription = 'Communities will appear here.';
  @override
  String? communitiesMembersOnlyMessage = 'Join this community to view programs.';
  @override
  String? communitiesNoProgramsTitle = 'No programs yet';

  @override
  String? communitiesNoJoinRequests = 'No pending requests';
  @override
  String? communitiesJoinRequestPending = 'Pending';
  @override
  String? communitiesApprove = 'Approve';
  @override
  String? communitiesReject = 'Reject';
  @override
  String? communitiesMyTitle = 'My Communities';
  @override
  String? communitiesMyEmpty = 'You have not joined any communities yet.';
  @override
  String? communitiesExploreButton = 'Explore';

  // Super Admin
  @override
  String? superAdminPanelTitle = 'Super Admin';
  @override
  String? superAdminPanelDescription = 'Manage communities';
  @override
  String? superAdminRequiresLargeScreen = 'Super Admin panel requires tablet/desktop.';
  @override
  String? superAdminManage = 'Manage';

  @override
  String? superAdminCreateCommunityTitle = 'Create community';
  @override
  String? superAdminEditCommunityTitle = 'Edit community';
  @override
  String? superAdminCreate = 'Create';
  @override
  String? superAdminCommunityCreated = 'Community created';
  @override
  String? superAdminCommunityUpdated = 'Community updated';

  @override
  String? superAdminArchiveTitle = 'Archive community';
  @override
  String? superAdminArchiveDescription = 'Archive {name}?';
  @override
  String? superAdminArchive = 'Archive';
  @override
  String? superAdminCommunityArchived = 'Community archived';
  @override
  String? superAdminActiveChip = 'Active';
  @override
  String? superAdminArchivedChip = 'Archived';

  // Profile Page - Statistics & Support
  @override
  String? statistics = 'Statistics';
  @override
  String? score = 'Score';
  @override
  String? completedChapters = 'Completed Chapters';
  @override
  String? security = 'Security';
  @override
  String? changePassword = 'Change Password';
  @override
  String? setPassword = 'Set Password';
  @override
  String? updatePasswordDescription =
      'Update your login password';
  @override
  String? setPasswordDescription =
      'Add password protection to your account';
  @override
  String? passwordResetNote =
      'Note: If you forget your password, contact support to reset it.';
  @override
  String? support = 'Support';
  @override
  String? supportContact = 'Support Contact';
  @override
  String? whatsAppSupport = 'WhatsApp Support';
  @override
  String? chatWithUs = 'Chat with us';
  @override
  String? callSupportError = 'Could not launch phone call';
  @override
  String? whatsAppSupportError = 'Could not launch WhatsApp';
  @override
  String? callSupport = 'Call Support';
}
