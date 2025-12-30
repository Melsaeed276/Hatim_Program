import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../models/models.dart';
import '../../service/user_services.dart';

class GroupMembersPage extends StatefulWidget {
  final GroupModel group;

  const GroupMembersPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  final Map<String, UserModel?> _userCache = {};
  final _userServices = UserServices();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    for (final userId in widget.group.usersID) {
      try {
        // Use UserServices directly without updating the controller
        final user = await _userServices.getUserByPhoneNumber(userId);
        if (mounted) {
          setState(() {
            _userCache[userId] = user;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _userCache[userId] = null;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRemoveUser(String userId, String displayName) async {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: false,
    ).getLanguage();
    final groupController = Provider.of<GroupController>(
      context,
      listen: false,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove User'),
        content: Text(
          'Are you sure you want to remove $displayName from this group?',
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Show loading
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Remove user from group
      await groupController.removeUserFromGroup(widget.group.groupID, userId);

      // Remove group from user's groups list using UserServices directly
      final user = await _userServices.getUserByPhoneNumber(userId);
      if (user != null) {
        user.groups.remove(widget.group.groupID);
        await _userServices.updateUser(user);
      }

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();

        // Remove from local cache and update UI
        setState(() {
          _userCache.remove(userId);
          widget.group.usersID.remove(userId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User removed successfully'),
          ),
        );

        // If no more users, go back with result
        if (widget.group.usersID.isEmpty && mounted) {
          // Use Navigator.pop with result since GoRouter doesn't support return values well
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context).getLanguage();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${lang.usersLabel ?? 'Users'} - ${widget.group.name}',
        ),
      ),
      body: widget.group.usersID.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No users in this group yet',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : _isLoading && _userCache.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: widget.group.usersID.length,
                  itemBuilder: (context, index) {
                    final userId = widget.group.usersID[index];
                    final user = _userCache[userId];
                    final displayName = user?.name ?? userId;
                    final isLoading = !_userCache.containsKey(userId);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: ListTile(
                        leading: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.person),
                        title: Text(displayName),
                        subtitle: Text(
                          userId,
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: isLoading
                              ? null
                              : () => _handleRemoveUser(userId, displayName),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
