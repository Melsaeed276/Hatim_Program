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
    AppRoutes.goToGroupMembers(context, group.groupID);
  }

  void _navigateToGroupDetails(GroupModel group) {
    if (!mounted) return;
    AppRoutes.goToAdminGroupDetails(context, group.groupID);
  }

  Widget _buildStatusChip(GroupStatus status, ThemeData theme, dynamic lang) {
    Color backgroundColor;
    Color foregroundColor;
    String label;

    switch (status) {
      case GroupStatus.active:
        backgroundColor = theme.colorScheme.primaryContainer;
        foregroundColor = theme.colorScheme.onPrimaryContainer;
        label = 'Active';
        break;
      case GroupStatus.waiting:
        backgroundColor = theme.colorScheme.secondaryContainer;
        foregroundColor = theme.colorScheme.onSecondaryContainer;
        label = 'Waiting';
        break;
      case GroupStatus.finished:
        backgroundColor = theme.colorScheme.tertiaryContainer;
        foregroundColor = theme.colorScheme.onTertiaryContainer;
        label = 'Finished';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _navigateToGroupDetails(group),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      group.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildStatusChip(group.status, theme, lang),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.tag,
                                    size: 16,
                                    color: theme.colorScheme.outline,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    group.groupID,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.people_outline,
                                    size: 16,
                                    color: theme.colorScheme.outline,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${group.usersID.length}/${group.userCount}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    group.calendarType == GroupCalendarType.hijri
                                        ? Icons.calendar_month
                                        : Icons.calendar_today,
                                    size: 16,
                                    color: theme.colorScheme.outline,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    group.calendarType == GroupCalendarType.hijri
                                        ? 'Hijri'
                                        : 'Gregorian',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton.tonalIcon(
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: Text(lang.editLabel ?? 'Edit'),
                                    onPressed: () => _navigateToGroupDetails(group),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filledTonal(
                                    icon: const Icon(Icons.people),
                                    tooltip: lang.membersLabel ?? 'View Members',
                                    onPressed: () => _navigateToGroupMembers(group),
                                  ),
                                  if (group.usersID.length < group.userCount) ...[
                                    const SizedBox(width: 8),
                                    IconButton.filledTonal(
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
                                  ],
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: theme.colorScheme.error,
                                    ),
                                    tooltip: lang.deleteGroup ?? 'Delete Group',
                                    onPressed: () =>
                                        _handleDeleteGroup(group, adminPassword),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
