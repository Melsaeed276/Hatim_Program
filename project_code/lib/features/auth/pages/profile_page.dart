import 'package:flutter/material.dart';
import 'package:hatim_program/features/community/controllers/community_controller.dart';
import 'package:hatim_program/features/community/services/community_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/controllers.dart';
import '../../../core/routing/page_route.dart';
import '../controllers/controllers.dart';
import '../models/models.dart';

/// Reusable profile content widget that can be embedded in tabs or used standalone
class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  String supportPhoneNumber = '+095388902129';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch phone call to $phoneNumber'),
          ),
        );
      }
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    // Clean the phone number (remove + and spaces for the URL if needed,
    // though wa.me often handles it. Best to strip non-digits).
    // The user provided +095388902129.
    // We will clean it to be safe.
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final Uri launchUri = Uri.parse('https://wa.me/$cleanNumber');

    if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = Provider.of<LocalizationController>(context, listen: true);
    final userController = Provider.of<UserController>(context, listen: true);
    final user = userController.userModel;
    final CommunityController? communityController =
        Provider.of<CommunityController?>(context, listen: true);
    final userId = userController.getCurrentUserID;

    // Update support phone number based on current user data
    if (user != null) {
      supportPhoneNumber = user.joinedByAdminId != null
          ? '+90${user.joinedByAdminId}'
          : '+095388902129';
    }

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.isSuperAdmin) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: Text(
                  local.getLanguage().superAdminPanelTitle ?? 'Super Admin',
                ),
                subtitle: Text(
                  local.getLanguage().superAdminPanelDescription ??
                      'Manage communities',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.go('/${AppRoutes.superAdmin}'),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: theme.textTheme.headlineSmall,
                            ),
                            Text(
                              user.phoneNumber,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (user.isAdmin)
                              const Chip(
                                label: Text('Admin'),
                                backgroundColor: Colors.red,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (communityController != null) ...[
            // My Communities: active + pending
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.getLanguage().communitiesMyTitle ??
                          'My Communities',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<List<CommunityMembershipRef>>(
                      stream: communityController.service
                          .streamMyMembershipRefs(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text(
                            snapshot.error.toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          );
                        }

                        final items =
                            (snapshot.data ?? const <CommunityMembershipRef>[])
                                .where(
                                  (x) =>
                                      x.member.status == 'active' ||
                                      x.member.status == 'pending',
                                )
                                .toList();

                        if (items.isEmpty) {
                          return Text(
                            local.getLanguage().communitiesMyEmpty ??
                                'You have not joined any communities yet.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        }

                        return Column(
                          children: items.map((x) {
                            final statusLabel = x.member.status == 'pending'
                                ? (local.getLanguage().communitiesPendingChip ??
                                      'Pending')
                                : (local.getLanguage().communitiesMemberChip ??
                                      'Member');
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.groups_outlined),
                              title: Text(
                                x.communityId.isNotEmpty
                                    ? x.communityId
                                    : (local.getLanguage().unknown ??
                                          'Unknown'),
                              ),
                              subtitle: Text(statusLabel),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: x.communityId.isEmpty
                                  ? null
                                  : () => context.go(
                                      '/${AppRoutes.communities}/${x.communityId}',
                                    ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () =>
                            context.go('/${AppRoutes.communities}'),
                        icon: const Icon(Icons.explore_outlined),
                        label: Text(
                          local.getLanguage().communitiesExploreButton ??
                              'Explore',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Statistics Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.getLanguage().statistics ?? 'Statistics',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  // Score at the top as requested
                  _buildStatCard(
                    context,
                    local.getLanguage().score ?? 'Score',
                    user.score.toStringAsFixed(1), // Formatting score
                    Icons.star,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 8),
                  _buildStatCard(
                    context,
                    local.getLanguage().completedChapters ??
                        'Completed Chapters',
                    user.totalCompletedChapters.toString(),
                    Icons.article,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Security Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.getLanguage().security ?? 'Security',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(
                      _hasPasswordSet(user)
                          ? (local.getLanguage().changePassword ??
                                'Change Password')
                          : (local.getLanguage().setPassword ?? 'Set Password'),
                    ),
                    subtitle: Text(
                      _hasPasswordSet(user)
                          ? (local.getLanguage().updatePasswordDescription ??
                                'Update your login password')
                          : (local.getLanguage().setPasswordDescription ??
                                'Add password protection to your account'),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showPasswordDialog(user),
                  ),
                  if (_hasPasswordSet(user))
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                      ),
                      child: Text(
                        local.getLanguage().passwordResetNote ??
                            'Note: If you forget your password, contact support at +095388902129 to reset it.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Support Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.getLanguage().support ?? 'Support',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: Text(
                      local.getLanguage().supportContact ?? 'Support Contact',
                    ),
                    subtitle: Text(supportPhoneNumber),
                    trailing: const Icon(Icons.phone),
                    onTap: () {
                      _makePhoneCall(supportPhoneNumber);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat), // Whatsapp/Chat icon
                    title: Text(
                      local.getLanguage().whatsAppSupport ?? 'WhatsApp Support',
                    ),
                    subtitle: Text(
                      local.getLanguage().chatWithUs ?? 'Chat with us',
                    ),
                    trailing: const Icon(Icons.arrow_outward),
                    onTap: () {
                      _openWhatsApp(supportPhoneNumber);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool fullWidth = false,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasPasswordSet(UserModel user) {
    if (user.isAdmin) {
      return user.adminPassword != null && user.adminPassword!.isNotEmpty;
    } else {
      return user.password != null && user.password!.isNotEmpty;
    }
  }

  void _showPasswordDialog(UserModel user) async {
    final local = Provider.of<LocalizationController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    final hasPassword = _hasPasswordSet(user);
    final title = hasPassword
        ? (local.getLanguage().changePassword ?? 'Change Password')
        : (local.getLanguage().setPassword ?? 'Set Password');
    final description = hasPassword
        ? (local.getLanguage().updatePasswordDescription ??
              'Enter your current password and a new one.')
        : (local.getLanguage().setPasswordDescription ??
              'Set a password to secure your account.');

    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final lang = local.getLanguage();
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(description),
                const SizedBox(height: 16),
                if (hasPassword) ...[
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: lang.password ?? 'Password',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.pleaseEnterYourPassword ??
                            'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: lang.password ?? 'Password',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.pleaseEnterYourPassword ??
                          'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(lang.close ?? 'Close'),
            ),
            FilledButton(
              onPressed: () async {
                final bool isFormValid =
                    formKey.currentState?.validate() ?? false;
                if (!isFormValid) {
                  return;
                }

                if (hasPassword) {
                  final verified = await authController.verifyUserPassword(
                    currentPasswordController.text,
                    user,
                  );
                  if (!verified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang.wrongPasswordMessage ?? 'Authentication failed',
                        ),
                      ),
                    );
                    return;
                  }
                }

                final success = user.isAdmin
                    ? await authController.setAdminPassword(
                        newPasswordController.text,
                      )
                    : await authController.setUserPassword(
                        newPasswordController.text,
                      );

                Navigator.of(context).pop(success);
              },
              child: Text(lang.continueText ?? 'Continue'),
            ),
          ],
        );
      },
    );

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    }
  }
}

/// Standalone ProfilePage for route-based navigation (backwards compatibility)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.goToHome(context),
        ),
      ),
      body: const ProfileContent(),
    );
  }
}
