import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/contollers.dart';
import '../../models/models.dart';
import '../over_screens/progress_indicator.dart';
import '../../page_route.dart';
import 'update_hatim_dialog.dart';

class HatimsPage extends StatefulWidget {
  // final Future<List<HatimRoundModel>>? hatimModel;
  const HatimsPage({super.key});

  @override
  State<HatimsPage> createState() => _HatimsPageState();
}

class _HatimsPageState extends State<HatimsPage> {
  final ScrollController _scrollController = ScrollController();

  Future<GroupModel?>? _groupFuture;

  late final bool? isAdmin;
  @override
  void initState() {

    //print the current page route


    super.initState();
    final groupController =
        Provider.of<GroupController>(context, listen: false);

    final userController = Provider.of<UserController>(context, listen: false);

    isAdmin = userController.userModel?.isAdmin ?? false;
    _groupFuture =
        groupController.getGroupByID(groupController.getCurrentGroupID);


    // Scroll to the current hatim
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();

    final groupController =
        Provider.of<GroupController>(context, listen: true);

    final userController = Provider.of<UserController>(context, listen: false);
    final userID = userController.getCurrentUserID;



    //Theme
    final theme = Theme.of(context);
    final themeColor = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: Text(lang.myHatimsOfThisGroup!),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {

              groupController.setGroupID = '0';


              AppRoutes.goBack(context);
            },
          ),
        ),
        body: FutureBuilder<GroupModel?>(
          future: _groupFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data != null){
              final GroupModel group = snapshot.data!;
              final List<HatimRoundModel> hatims = group.getHatimGroups();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, bottom: 5),
                    child: Text(
                      isAdmin ?? true
                          ? lang.youCanFollowAllTheUsersHatimsOfThatXGroupFromHere!(
                              group: group.groupID)
                          : lang.youAreRightNowAtThatXHatimAndYouNeedToReadThisXChapter!(
                              hatim: group
                                  .getCurrentHatimOfUser(userID)
                                  .toString(),
                              chapter:
                                  group.getCurrentHatimChapterOfUser(userID)),
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, bottom: 18, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                                isAdmin ?? false
                                    ? lang
                                        .toSeeMoreDetailsAboutTheHatimPressOnTheHatim!
                                    : lang
                                        .ifYouCompleteTheHatimYouNeedToPressOnTheHatimToUpdateYourHatimRound!,
                                style: theme.textTheme.labelLarge)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeColor.secondaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 8.0, right: 8.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: hatims.length,
                          itemBuilder: (context, index) {
                            final HatimRoundModel hatim = hatims[index];

                            final isCurrentIndex = isAdmin == true
                                ? group.getCurrentHatim() == index + 1
                                : group.getCurrentHatimOfUser(userID) ==
                                    index + 1;

                            final didUserCompleteHatim = isAdmin == true
                                ? group.hatimRounds[index].isAllUserCompleted()
                                : hatim.isHatimCompleted(userID);

                            // each hatim end date
                            final endDate = hatim.endDate;
                            final endDateString = isAdmin == true
                                ? '${lang.hatimWillEndAt} : ${endDate.day}/${endDate.month}/${endDate.year}'
                                : '${lang.youNeedToCompleteTheHatimBeforeThatDate}: ${endDate.day}/${endDate.month}/${endDate.year}';

                            final startHatimDateMessage =
                                '${lang.theHatimWillStartAtThatDate}: ${hatim.startDate.day}/${hatim.startDate.month}/${hatim.startDate.year}';
                            final userCopmletedHatimMessage =
                                '${lang.theHatimIsOverAtThatDate}: ${endDate.day}/${endDate.month}/${endDate.year}';

                            final title = isAdmin == true
                                ? '${lang.hatim}: ${hatim.roundID}. ${lang.week}'
                                : '${lang.hatimChapter!}: ${hatim.getCurrentHatimChapterOfUser(userID)}';

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () async {
                                  ///if the hatim is completed show snackbar saying it is completed
                                  ///if the hatim is the current one will open a dialog to update the hatim
                                  ///if the hatim is not the current one will show a snackbar saying that the hatim is not the current one
                                  ///
                                  if (isAdmin ?? false) {
                                    // got to the hatim details page
                                    // Navigator.of(context).pushNamed(
                                    //     AppRoutes.hatim,
                                    //     arguments: hatim);

                                    AppRoutes.goToHatim(context, hatim);

                                  } else if (didUserCompleteHatim) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(lang.theHatimIsCompleted!),
                                    ));
                                  } else if (isCurrentIndex) {
                                    final result = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UpdateHatimDialog(
                                          chapter: hatim
                                              .getCurrentHatimChapterOfUser(userID),
                                        );
                                      },
                                    );

                                    if (result != null && result) {
                                      // The user confirmed they have completed the Hatim
                                      group.completeHatimOfUser(userID);
                                      groupController.updateGroup(group);
                                      setState(() {
                                        double itemHeight = 85;
                                        // replace with your desired index
                                        _scrollController.animateTo(
                                          index * itemHeight,
                                          duration: const Duration(seconds: 2),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(lang
                                          .youNeedToCompleteThisHatimToBeAbleToGoToTheNextHatim!),
                                    ));
                                  }
                                },
                                child: Card(
                                  color: didUserCompleteHatim
                                      ? themeColor.surfaceContainerHighest
                                      : isCurrentIndex
                                          ? themeColor.primaryContainer
                                          : themeColor.surface,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: didUserCompleteHatim
                                              ? themeColor.surfaceContainerHigh
                                              : isCurrentIndex
                                                  ? themeColor.primary
                                                  : themeColor.surfaceContainer,
                                          child: Text(
                                            '${hatim.roundID}',
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                              color: didUserCompleteHatim
                                                  ? themeColor.onSurfaceVariant
                                                  : isCurrentIndex
                                                      ? themeColor.onPrimary
                                                      : themeColor.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: theme.textTheme.titleLarge!
                                                    .copyWith(
                                                  color: didUserCompleteHatim
                                                      ? themeColor
                                                          .onSurfaceVariant
                                                      : isCurrentIndex
                                                          ? themeColor
                                                              .onPrimaryContainer
                                                          : themeColor.onSurface,
                                                ),
                                              ),
                                              Text(
                                                  didUserCompleteHatim
                                                      ? userCopmletedHatimMessage
                                                      : isCurrentIndex
                                                          ? endDateString
                                                          : startHatimDateMessage,
                                                  maxLines: 2,
                                                  style: theme
                                                      .textTheme.labelMedium!
                                                      .copyWith(
                                                    color: didUserCompleteHatim
                                                        ? themeColor
                                                            .onSurfaceVariant
                                                        : isCurrentIndex
                                                            ? themeColor.error
                                                            : themeColor
                                                                .onSurface,
                                                    fontWeight: isCurrentIndex
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  )),
                                            ],
                                          ),
                                        ),
                                       // const Spacer(),
                                        isAdmin ?? false
                                            ? ProgressIndicatorWithNumber(
                                                currentValue: hatim
                                                    .howManyUserCompleted(),
                                              )
                                            : Icon(
                                                didUserCompleteHatim
                                                    ? Icons.check_box_outlined
                                                    : isCurrentIndex
                                                        ? Icons
                                                            .check_box_outline_blank
                                                        : Icons
                                                            .indeterminate_check_box_outlined,
                                                color: didUserCompleteHatim
                                                    ? themeColor
                                                        .onSurfaceVariant
                                                    : isCurrentIndex
                                                        ? themeColor
                                                            .onTertiaryContainer
                                                        : themeColor.onSurface,
                                              ),

                                        const SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }else {
              return const Center(child: Text('No data'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var group = await groupController
                .getGroupByID(groupController.getCurrentGroupID);

            setState(() {
              double itemHeight = 80;
              //group.getCurrentHatimOfUser(userID)
              int index = group!.getCurrentHatimOfUser(userID);
              // replace with your desired index
              _scrollController.animateTo(
                index <= 6 ? (index).toDouble() : (index * itemHeight),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
              );
            });
          },
          label: Text(lang.myCurrentHatim!),
          // child: const Icon(Icons.arrow_downward_outlined),
        ));
  }
}
