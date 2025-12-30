import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../models/models.dart';
import '../../page_route.dart';
import '../dialogs/admin_password_dialog.dart';
import '../dialogs/user_selection_dialog.dart';
import '../hone_page_views/add_hatim_group_dialog.dart';

class AdminGroupsManagementView extends StatefulWidget {
  const AdminGroupsManagementView({super.key});

  @override
  State<AdminGroupsManagementView> createState() =>
      _AdminGroupsManagementViewState();
}

class _AdminGroupsManagementViewState extends State<AdminGroupsManagementView> {
  Future<List<GroupModel>>? _ownedGroupsFuture;
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _refreshOwnedGroups();
        }
      });
    }
  }

  void _refreshOwnedGroups() {
    if (!mounted) return;
    
    final userController = Provider.of<UserController>(context, listen: false);
    final groupController = Provider.of<GroupController>(
      context,
      listen: false,
    );
    final currentUserId = userController.getCurrentUserID;

    if (mounted) {
      setState(() {
        _ownedGroupsFuture = groupController.getGroupsCreatedByAdmin(
          currentUserId,
        );
      });
    }
  }

  Future<void> _handleDeleteGroup(
    GroupModel group,
    String adminPassword,
  ) async {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: false,
    ).getLanguage();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.deleteGroup ?? 'Delete Group'),
        content: Text(
          '${lang.deleteGroupConfirmation ?? 'Are you sure you want to delete this group'} "${group.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(lang.close ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(lang.deleteButton ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final passwordVerified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdminPasswordDialog(storedPassword: adminPassword),
    );

    if (passwordVerified != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang.adminPasswordIncorrect ?? 'Password verification failed',
            ),
          ),
        );
      }
      return;
    }

    final groupController = Provider.of<GroupController>(
      context,
      listen: false,
    );
    try {
      await groupController.deleteGroupAsAdmin(group.groupID);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang.groupDeletedSuccessfully ?? 'Group deleted successfully',
            ),
          ),
        );
        _refreshOwnedGroups();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${lang.errorPrefix ?? 'Error'}: $e')),
        );
      }
    }
  }

  void _navigateToGroupMembers(GroupModel group) {
    if (!mounted) return;
    AppRoutes.goToGroupMembers(context, group);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final userController = Provider.of<UserController>(context, listen: true);
    final theme = Theme.of(context);

    if (userController.userModel == null) return const SizedBox();
    final adminPassword = userController.userModel!.adminPassword ?? '';

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  lang.myCreatedGroups ?? 'My Created Groups',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.tertiaryContainer,
                    backgroundColor: theme.colorScheme.tertiaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: () {
                    showAddHatimGroupSheet(
                      context,
                      adminId: userController.getCurrentUserID,
                    ).then((success) {
                      if (success == true) {
                        _refreshOwnedGroups();
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      lang.addGroup ?? 'Create Group',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_ownedGroupsFuture == null)
          const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
        else
          FutureBuilder<List<GroupModel>>(
            future: _ownedGroupsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${lang.errorPrefix ?? 'Error'}: ${snapshot.error}',
                  ),
                );
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        lang.youHaveNotCreatedAnyGroupsYet ??
                            'You have not created any groups yet',
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          showAddHatimGroupSheet(
                            context,
                            adminId: userController.getCurrentUserID,
                          ).then((success) {
                            if (success == true) {
                              _refreshOwnedGroups();
                            }
                          });
                        },
                        child: Text(lang.addGroup ?? 'Create Group'),
                      ),
                    ],
                  ),
                );
              } else {
                final groups = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        title: Text(
                          group.name,
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${lang.groupIDLabel ?? 'Group ID'}: ${group.groupID}',
                            ),
                            Text(
                              '${lang.statusLabel ?? 'Status:'} ${group.status.toString().split('.').last}',
                            ),
                            Text(
                              '${lang.usersLabel ?? 'Users:'} ${group.usersID.length}/${group.userCount}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.people),
                              tooltip: 'View Members',
                              onPressed: () => _navigateToGroupMembers(group),
                            ),
                            if (group.usersID.length < group.userCount)
                              IconButton(
                                icon: const Icon(Icons.person_add),
                                tooltip: 'Add User',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        UserSelectionDialog(group: group),
                                  ).then((_) => _refreshOwnedGroups());
                                },
                              ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              tooltip: 'Delete Group',
                              onPressed: () =>
                                  _handleDeleteGroup(group, adminPassword),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
      ],
    );
  }
}
