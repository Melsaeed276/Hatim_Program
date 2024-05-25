
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


 late String? show;

  late String? skip;

  late String? applicationColor;

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

  ///Groups

// group
  late String? group;

  //groups
  late String? groups;

  //group name
  late String? groupName;

  //please enter your group name

  late String? pleaseEnterYourGroupName;

  //group name is empty

  late String? groupNameIsEmpty;

  // you do not have group yet
  late String? youDoNotHaveGroupYet;

  // please join a group you need to press on the join button
  late String? pleaseJoinAGroupYouNeedToPressOnJoinButton;

  // group is full
  late String? groupIsFull;

  //group is not full
  late String? groupIsNotFull;

  // you can join the group by pressing on the plus button
  late String? youCanJoinTheGroupByPressingOnThePlusButton;

  // the group is available
  late String? theGroupIsAvailable;

  //the group is not active yet please wait until the app members join
  late String? theGroupIsNotActiveYetPleaseWaitUntilTheAppMembersJoin;

  // the group is not available
  late String? theGroupIsNotAvailable;

  // group is Started
  late String? groupIsStarted;

  // group is not stated
  late String? groupIsNotStated;

  // X person are in the group
  late String Function({required int count})? xPersonAreInTheGroup;

  // there is still X place in the group to start
  late String Function({required int count})? thereIsStillXPlaceInTheGroupToStart;

// my groups
  late String? myGroups;

  // add group
  late String? addGroup;

  //join group
  late String? joinGroup;

  // the Current Hatim is X
  late String Function({required String hatimName})? theCurrentHatimIsX;

  // this is the week X of the Hatim
  late String Function({required String week})? thisIsTheWeekXOfTheHatim;

  late String? newText;

  // you can follow your Hatim and update it from here.
  late String? youCanFollowYourHatimAndUpdateItFromHere;

  //you can follow all the users hatims of that X group from here
  late String Function({required String group})? youCanFollowAllTheUsersHatimsOfThatXGroupFromHere;

  // join
  late String? join;

  //hatim
  late String? hatim;

  //hatim chapter
  late String? hatimChapter;

  //hatim chapter number
  late String? hatimChapterNumber;

  //did you complete the hatim
  late String? didYouCompleteTheHatim;

  //yes
  late String? yes;

  //no
  late String? no;

  //the hatim is completed
  late String? theHatimIsCompleted;

  //the hatim is not completed
  late String? theHatimIsNotCompleted;

  //This is your current hatims
  late String? thisIsYourCurrentHatims;

  //If you complete the hatim, you need to press on the hatim to update your hatim round
  late String? ifYouCompleteTheHatimYouNeedToPressOnTheHatimToUpdateYourHatimRound;

  //to see more details about the hatim press on the hatim
  late String? toSeeMoreDetailsAboutTheHatimPressOnTheHatim;

  //are you sure that you completed the hatim?
  late String? areYouSureThatYouCompletedTheHatim;

  //the hatim is completed successfully
  late String? theHatimIsCompletedSuccessfully;

  //the current hatim is about to over please update your hatim
  late String? theCurrentHatimIsAboutToOverPleaseUpdateYourHatim;

  // this hatim is completed
  late String? thisHatimIsCompleted;

// this hatim is not completed
late String? thisHatimIsNotCompleted;

// you need to complete this hatim to be able to go to the next hatim
late String? youNeedToCompleteThisHatimToBeAbleToGoToTheNextHatim;

//there is no available groups for you to join right now, you need to talk to the admin to add new group
late String? thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup;

// my hatims of this group
late String? myHatimsOfThisGroup;

// my current hatim
late String? myCurrentHatim;

//group status
late String? groupStatus;

// You need to complete the hatim before that date
late String? youNeedToCompleteTheHatimBeforeThatDate;

// The Hatim is over at that Date
late String? theHatimIsOverAtThatDate;

//the hatim will start at that date
late String? theHatimWillStartAtThatDate;

// You are right now at that X hatim and you need to read this X chapter
late String Function({required String hatim, required int chapter})? youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter;

// did you read the X chapter? if yes then press on yes to update your hatim round
late String Function({required int chapter})? didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound;

// Hatim end date
late String? hatimEndDate;

//hatim will end at:
late String? hatimWillEndAt;

late String? week;
}

