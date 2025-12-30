import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/contollers.dart';
import '../../models/models.dart';

class UserSelectionDialog extends StatefulWidget {
  final GroupModel group;

  const UserSelectionDialog({super.key, required this.group});

  @override
  State<UserSelectionDialog> createState() => _UserSelectionDialogState();
}

class _UserSelectionDialogState extends State<UserSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userController = Provider.of<UserController>(
        context,
        listen: false,
      );
      context.read<AdminReferralController>().loadAdminReferralData(
        userController.getCurrentUserID,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> _filterUsers(List<UserModel> users) {
    if (_searchQuery.isEmpty) return users;
    
    final query = _searchQuery.toLowerCase();
    return users.where((user) {
      final name = user.name.toLowerCase();
      final phone = user.phoneNumber.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context).getLanguage();
    final referralController = Provider.of<AdminReferralController>(context);
    final groupController = Provider.of<GroupController>(context);

    final eligibleUsers = referralController.getUsersNotInGroup(
      widget.group.usersID,
    );
    final filteredUsers = _filterUsers(eligibleUsers);

    return AlertDialog(
      title: Text(lang.selectUsersToAdd!),
      content: referralController.isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : eligibleUsers.isEmpty
          ? Text(lang.noReferredUsersFound!)
          : SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name or phone number',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  // User list
                  Expanded(
                    child: filteredUsers.isEmpty
                        ? Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? lang.noReferredUsersFound!
                                  : 'No users found matching "$_searchQuery"',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return ListTile(
                                title: Text(user.name),
                                subtitle: Text(user.phoneNumber),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () async {
                                    final result =
                                        await groupController.addUserToGroup(
                                      widget.group.groupID,
                                      user.id,
                                    );
                                    if (result.isSuccess) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${user.name} added successfully',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result.error ??
                                                  'Failed to add user',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(lang.close!),
        ),
      ],
    );
  }
}
