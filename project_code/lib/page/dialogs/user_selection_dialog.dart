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
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context).getLanguage();
    final referralController = Provider.of<AdminReferralController>(context);
    final groupController = Provider.of<GroupController>(context);

    final eligibleUsers = referralController.getUsersNotInGroup(
      widget.group.usersID,
    );

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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: eligibleUsers.length,
                itemBuilder: (context, index) {
                  final user = eligibleUsers[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.phoneNumber),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () async {
                        final result = await groupController.addUserToGroup(
                          widget.group.groupID,
                          user.id,
                        );
                        if (result.isSuccess) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${user.name} added successfully',
                                ),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.error ?? 'Failed to add user',
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(lang.close!),
        ),
      ],
    );
  }
}
