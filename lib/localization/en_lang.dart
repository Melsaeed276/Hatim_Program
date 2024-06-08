

import 'dart:ui';

import 'localization.dart';

class ENText implements Localization {
  @override
  TextDirection textDirection = TextDirection.ltr;

  // App
  @override
  String? appDescription =
      'Guess the Topic game is an application that aims for people to come together and socialize.';

  @override
  String? appTitle = 'YAVUZ SELİM VAKFI HATİM ÇİZELGE TAKİP FORMU';

  // Authentication
  @override
  String? email = 'Email';

  @override
  String? pleaseCheckYourEmail = 'Please Check Your Email';

  @override
  String? pleaseEnterYourEmail = 'Please Enter Your Email';

  @override
  String? emailAlreadyExist = 'Email Already Exist';

  @override
  String? emailNotValid = 'Email Not Valid';

  @override
  String? pleaseEnterValidEmail = 'Please Enter Valid Email';

  @override
  String? passwordLengthError = 'Password length must be at least 6 characters';

  @override
  String? passwordNotValid = 'Password must contain at least one number';

  @override
  String? pleaseEnterYourPassword = 'Please Enter Your Password';
  @override
  String? logOut = 'Sign Out';

  @override
  String? login = 'Login';

  @override
  String? password = 'Password';

  @override
  String? register = 'Register';

  @override
  String? registerText = 'Don\'t you have an account yet?';

  @override
  String? userName = 'User Name';

  @override
  String? userNotFound = 'No user Found';

  @override
  String? loginText = 'Do you have an account?';

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

  // Internet Dialog
  @override
  String? noInternetWarningDialogText =
      'No internet connection detected at this time. The game needs an internet connection to constantly update your game data. Please reconnect to continue';

  @override
  String? languageDialogDoneButtonText = 'Done';

  // App Messages
  @override
  String? alreadyExistMessage = 'The account already exists';

  @override
  String? loginMessage = 'You have successfully entered';

  @override
  String? registerMessage = 'registration successful';

  @override
  String? wrongPasswordMessage =
      'You have entered the wrong information, please check again';

  @override
  String? signOutMessage = 'Signed out successfully';

  @override
  String? signOutErrorMessage = 'Error in signing out';

  @override
  String? categoryExistMessage = 'Category exists';

  @override
  String? categoryNotExistMessage = 'Category does not exist';

  @override
  String? topicExistMessage = 'Topic exists';

  @override
  String? topicNotExistMessage = 'Topic does not exist';

  @override
  String? allCategoriesErrorMessage = 'An error occurred!';



  @override
  String? addCategoryToDatabaseSuccessMessage =
      'A new category has been added successfully!';

  @override
  String? addCategoryToDatabaseErrorMessage =
      'An error occurred while adding a new category!';

  @override
  String? addTopicToDatabaseSuccessMessage = 'Topics added successfully!';

  @override
  String? addTopicToDatabaseErrorMessage =
      'An error occurred while adding topics to the database!';

  @override
  String? addPlayerStartGameErrorMessage =
      'Players must first fill in all the blank name inputs and'
      ' check if there is a problem with the names in the list';

  @override
  String? largeWebViewError =
      "This device is not supported. Please play the game only on your mobile browser.";

  //Main Menu

  @override
  String? homePageTitle = 'Main Menu';

  @override
  String? adminPanelText = 'Admin Panel';

  @override
  String? randomCategoryButtonText = 'Random Category';

  @override
  String? showAllCategoriesButtonText = 'Show All Categories';

  //Admin Panel
  @override
  String? enterCategory = 'Enter category name';

  @override
  String? enterTopic = 'Enter topic name';

  @override
  String? addNewCategory = 'Add it as a new Category';

  @override
  String? topicAlreadyExistErrorMessage =
      'This topic already exists in the database!';

  @override
  String? topicAlreadyExistInAddedErrorMessage =
      'This topic already exists in the list!';

  //Bottom Sheet
  @override
  String? account = 'Account';

  @override
  String? theme = 'Theme';

  @override
  String? dark = 'Dark';

  @override
  String? light = 'Light';

  @override
  String? system = 'System';

  @override
  String? language = 'Language';

  @override
  String? done = 'Done';

  //Add Player



  // Voting Dialog
  @override
  String? explanationText =
      'Please choose who do you think is out of the topic.';

  @override
  String? votingDialogCancelButtonText = 'Cancel';

  @override
  String? votingDialogResetButtonText = 'Reset';

  @override
  String? votingDialogSubmitButtonText = 'Submit';

  @override
  String? votingDialogCallButtonText = 'Voting';

  @override
  String? returnToGame = "Return to Game";

  @override
  String? voteAgain = "Vote Again";

  @override
  String? votingStalemateText =
      "It seems like you could not decide on the hidden person yet, either continue to play or vote again.";

  // Exit Dialog
  @override
  String? exitDialogCancelButtonText = 'No';

  @override
  String? exitDialogExitButtonText = 'Yes';

  @override
  String? exitDialogDescriptionText =
      'Are you sure that you want to exit the game?';

  // Logout Dialog
  @override
  String? logoutDialogDescriptionText =
      'Are you sure that you want to log out?';

  @override
  String? logoutDialogCancelButtonText = 'Cancel';

  @override
  String? logoutDialogLogoutButtonText = 'Logout';

  //Other Stuff

  @override
  String? add = 'Add';

  @override
  String? close = 'Close';

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
  String? vote = 'Vote';

  @override
  String? category = 'Category';

  @override
  String? topic = 'Topic';

  @override
  String? show = 'Show';


  @override
  String? skip = 'Skip';

  @override
  String? applicationColor = 'Game Color';

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
  String? nameIsEmpty = 'Name is empty';

  @override
  String? pleaseEnterYourName= 'Please Enter Your Name';

  @override
  String? nameShouldNotContainNumbers = 'Please enter only your name without any numbers';

  @override
  String? somethingWentWrong = 'Error something went wrong';

  @override
  String? welcome = 'Welcome';

  @override
  String? group = 'Group';

  @override
  String? groupIsFull = 'Group is full';

  @override
  String? groupIsNotFull  = 'Group is not full';

  @override
  String? groupIsNotStated = 'Group is not started yet';

  @override
  String? groupIsStarted = 'Group is started';

  @override
  String? groupName = 'Group Name';

  @override
  String? groupNameIsEmpty = 'Group name is empty';

  @override
  String? groups = 'Groups';

  @override
  String? pleaseEnterYourGroupName = 'Please enter your group name';

  @override
  String? pleaseJoinAGroupYouNeedToPressOnJoinButton = 'Please join a group you need to press on the join button';

  @override
  String? theGroupIsAvailable = 'The group is available';

  @override
  String? theGroupIsNotAvailable = 'The group is not available';

  @override
  String Function({required int count})? thereIsStillXPlaceInTheGroupToStart = ({required count}) => 'There is still $count place in the group to start';

  @override
  String Function({required int count})? xPersonAreInTheGroup = ({required count}) => '$count person are in the group';

  @override
  String? youCanJoinTheGroupByPressingOnThePlusButton = 'You can join the group by pressing on the plus button';

  @override
  String? youDoNotHaveGroupYet = 'You do not have group yet';

  // my groups
  @override
  String? myGroups = 'My Groups';

  // addGroup
  @override
  String? addGroup = 'Add a new Group';

  @override
  String? joinGroup = 'Join Group';

  @override
  String Function({required String hatimName})? theCurrentHatimIsX = ({required hatimName}) => 'The current hatim is $hatimName';

  @override
  String Function({required String week})? thisIsTheWeekXOfTheHatim = ({required week}) => 'This is the week $week of the Hatim';

  @override
  String? newText = 'New';

  @override
  String? youCanFollowYourHatimAndUpdateItFromHere = 'You can follow your hatim and update it from here';

  @override
  String? join = 'Join';

  @override
  String? areYouSureThatYouCompletedTheHatim = 'Are you sure that you completed the hatim?';

  @override
  String? didYouCompleteTheHatim = 'Did you complete the hatim?';

  @override
  String? hatim = 'Hatim';

  @override
  String? hatimChapter = 'Hatim Chapter';

  @override
  String? hatimChapterNumber = 'Hatim Chapter Number';

  @override
  String? ifYouCompleteTheHatimYouNeedToPressOnTheHatimToUpdateYourHatimRound = 'If you complete the hatim you need to press on the hatim to update your hatim round';

  @override
  String? no = 'No';

  @override
  String? theCurrentHatimIsAboutToOverPleaseUpdateYourHatim = 'The current hatim is about to over please update your hatim';

  @override
  String? theHatimIsCompleted = 'The hatim is completed';

  @override
  String? theHatimIsCompletedSuccessfully = 'The hatim is completed successfully';

  @override
  String? theHatimIsNotCompleted = 'The hatim is not completed';

  @override
  String? thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup = 'There is no available groups for you to join right now you need to talk to the admin to add new group';

  @override
  String? thisHatimIsCompleted = 'This hatim is completed';

  @override
  String? thisHatimIsNotCompleted = 'This hatim is not completed';

  @override
  String? thisIsYourCurrentHatims = 'This is your current hatims';

  @override
  String? yes = 'Yes';

  @override
  String? youNeedToCompleteThisHatimToBeAbleToGoToTheNextHatim = 'You need to complete this hatim to be able to go to the next hatim';

  @override
  String? myHatimsOfThisGroup = 'My hatims of this group';

  @override
  String? theGroupIsNotActiveYetPleaseWaitUntilTheAppMembersJoin = 'The group is not active yet please wait until the app members join';

  @override
  String? groupStatus = 'Group Status';

  @override
  String? theHatimIsOverAtThatDate = 'The Hatim is over at that Date';

  @override
  String? theHatimWillStartAtThatDate = 'The Hatim will start at that Date';

  @override
  String Function({required String hatim, required int chapter})? youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter = ({required hatim, required chapter}) => 'You are right now at that $hatim hatim and you need to read this $chapter chapter';

  @override
  String? youNeedToCompleteTheHatimBeforeThatDate = 'You need to complete the hatim before that date';

  @override
  String Function({required int chapter})? didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound = ({required chapter}) => 'Did you read the $chapter chapter? if yes then press on yes to update your hatim round';

  @override
  String? myCurrentHatim = 'My current';

  @override
  String Function({required String group})? youCanFollowAllTheUsersHatimsOfThatXGroupFromHere = ({required group}) => 'You can follow all the users hatims of that $group group from here';

  @override
  String? hatimEndDate = 'Hatim end date';

  @override
  String? hatimWillEndAt = 'hatim will end at: ';

  @override
  String? toSeeMoreDetailsAboutTheHatimPressOnTheHatim = 'to see more details about the hatim press on the hatim';

  @override
  String? week = 'week';

  }
