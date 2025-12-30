import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../localization/localization.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final userController = Provider.of<UserController>(
            context,
            listen: false,
          );
          context.read<AdminReferralController>().loadAdminReferralData(
            userController.getCurrentUserID,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final referralController = Provider.of<AdminReferralController>(context);
    final userController = Provider.of<UserController>(context, listen: false);
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReferralSection(
            context,
            lang,
            userController,
            referralController,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${lang.referredUsers ?? 'Referred Users'}: ${referralController.referredUsers.length}',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                if (referralController.referredUsers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        lang.noReferredUsersFound ??
                            'No users joined with your codes yet',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: referralController.referredUsers.length,
                    itemBuilder: (context, index) {
                      final user = referralController.referredUsers[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user.name[0].toUpperCase()),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.phoneNumber),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.person_remove_outlined,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    lang.removeUserFromReferrals ??
                                        'Remove User',
                                  ),
                                  content: Text(
                                    '${lang.areYouSureYouWantToRemoveThisUserFromYourReferrals ?? "Are you sure you want to remove this user from your referrals?"}\n\n${user.name}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(lang.cancel ?? 'Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            theme.colorScheme.error,
                                      ),
                                      child: Text(lang.remove ?? 'Remove'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final success = await referralController
                                    .removeUserFromReferrals(
                                      user.id,
                                      userController.getCurrentUserID,
                                    );
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        lang.userRemovedSuccessfully ??
                                            'User removed successfully',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralSection(
    BuildContext context,
    Localization lang,
    UserController userController,
    AdminReferralController referralController,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.referenceCode ?? 'Reference Codes',
                style: theme.textTheme.headlineSmall,
              ),
              if (referralController.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () => _showCreateCodeDialog(
                    context,
                    lang,
                    userController,
                    referralController,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (referralController.adminCodes.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: referralController.adminCodes.length,
                itemBuilder: (context, index) {
                  final code = referralController.adminCodes[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SelectableText(
                            code.code,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(lang.deleteCode ?? 'Delete Code'),
                                  content: Text(
                                    '${lang.areYouSureYouWantToDeleteThisCode ?? "Are you sure you want to delete this code?"}\n\n${code.code}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(lang.cancel ?? 'Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            theme.colorScheme.error,
                                      ),
                                      child: Text(lang.delete ?? 'Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await referralController.deleteCode(
                                  code.code,
                                  userController.getCurrentUserID,
                                );
                              }
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: theme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Text(lang.noData ?? 'No codes generated yet'),
        ],
      ),
    );
  }

  void _showCreateCodeDialog(
    BuildContext context,
    Localization lang,
    UserController userController,
    AdminReferralController referralController,
  ) {
    final TextEditingController codeController = TextEditingController();
    bool isCustom = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(lang.createReferenceCode ?? 'Create Reference Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<bool>(
                    title: Text(lang.randomCode ?? 'Random Code'),
                    value: false,
                    groupValue: isCustom,
                    onChanged: (value) {
                      setDialogState(() {
                        isCustom = value!;
                      });
                    },
                  ),
                  RadioListTile<bool>(
                    title: Text(lang.customCode ?? 'Custom Code'),
                    value: true,
                    groupValue: isCustom,
                    onChanged: (value) {
                      setDialogState(() {
                        isCustom = value!;
                      });
                    },
                  ),
                  if (isCustom)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: codeController,
                        decoration: InputDecoration(
                          hintText: lang.enterCustomCode ?? 'Enter custom code',
                          border: const OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(lang.cancel ?? 'Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final adminId = userController.getCurrentUserID;
                    bool success = false;
                    String? generatedCode;

                    if (isCustom) {
                      final customCode = codeController.text.trim();
                      if (customCode.isEmpty) return;
                      success = await referralController.createCustomCode(
                        customCode,
                        adminId,
                      );
                    } else {
                      generatedCode = await referralController.generateCode(
                        adminId,
                      );
                      success = generatedCode != null;
                    }

                    if (context.mounted) {
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang.referenceCodeCreatedSuccessfully ??
                                  'Reference code created successfully',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang.codeAlreadyExists ?? 'Code already exists',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(lang.add ?? 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
