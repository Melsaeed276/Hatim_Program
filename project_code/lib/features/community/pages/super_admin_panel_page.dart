import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/features/community/controllers/community_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/controllers.dart';
import '../../../core/routing/page_route.dart';
import '../../auth/controllers/controllers.dart';
import '../models/models.dart';

class SuperAdminPanelPage extends StatefulWidget {
  const SuperAdminPanelPage({super.key});

  @override
  State<SuperAdminPanelPage> createState() => _SuperAdminPanelPageState();
}

class _SuperAdminPanelPageState extends State<SuperAdminPanelPage> {
  Future<void> _showCreateCommunityDialog({
    required BuildContext context,
    required String createdBy,
  }) async {
    final lang = context.read<LocalizationController>().getLanguage();
    final controller = context.read<CommunityController>();

    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(lang.superAdminCreateCommunityTitle ?? 'Create community'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: lang.communitiesNameLabel ?? 'Name',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return lang.communitiesNameRequired ?? 'Name is required';
                  }
                  if (v.trim().length < 3) {
                    return lang.communitiesNameTooShort ?? 'Name is too short';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: lang.communitiesDescriptionLabel ?? 'Description',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return lang.communitiesDescriptionRequired ??
                        'Description is required';
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
              if (!(formKey.currentState?.validate() ?? false)) return;
              await controller.service.createCommunity(
                name: nameController.text.trim(),
                description: descController.text.trim(),
                createdBy: createdBy,
              );
              if (!context.mounted) return;
              Navigator.of(context).pop(true);
            },
            child: Text(lang.superAdminCreate ?? 'Create'),
          ),
        ],
      ),
    );

    nameController.dispose();
    descController.dispose();

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.superAdminCommunityCreated ?? 'Community created'),
        ),
      );
    }
  }

  Future<void> _showEditCommunityDialog({
    required BuildContext context,
    required Community community,
  }) async {
    final lang = context.read<LocalizationController>().getLanguage();
    final controller = context.read<CommunityController>();

    final nameController = TextEditingController(text: community.name);
    final descController = TextEditingController(text: community.description);
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(lang.superAdminEditCommunityTitle ?? 'Edit community'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: lang.communitiesNameLabel ?? 'Name',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return lang.communitiesNameRequired ?? 'Name is required';
                  }
                  if (v.trim().length < 3) {
                    return lang.communitiesNameTooShort ?? 'Name is too short';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: lang.communitiesDescriptionLabel ?? 'Description',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return lang.communitiesDescriptionRequired ??
                        'Description is required';
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
              if (!(formKey.currentState?.validate() ?? false)) return;
              await controller.service.updateCommunity(
                communityId: community.id,
                name: nameController.text.trim(),
                description: descController.text.trim(),
              );
              if (!context.mounted) return;
              Navigator.of(context).pop(true);
            },
            child: Text(lang.done ?? 'Done'),
          ),
        ],
      ),
    );

    nameController.dispose();
    descController.dispose();

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.superAdminCommunityUpdated ?? 'Community updated'),
        ),
      );
    }
  }

  Future<void> _confirmArchive({
    required BuildContext context,
    required Community community,
  }) async {
    final lang = context.read<LocalizationController>().getLanguage();
    final controller = context.read<CommunityController>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.superAdminArchiveTitle ?? 'Archive community'),
        content: Text(
          (lang.superAdminArchiveDescription ?? 'Archive {name}?').replaceAll(
            '{name}',
            community.name,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(lang.close ?? 'Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(lang.superAdminArchive ?? 'Archive'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await controller.service.archiveCommunity(community.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.superAdminCommunityArchived ?? 'Community archived',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();
    final user = context.watch<UserController>().userModel;
    final isSuperAdmin = user?.isSuperAdmin ?? false;

    // Route-level: must be tablet/desktop (per spec)
    final isLarge = MediaQuery.of(context).size.width > 600;
    if (!isLarge) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.superAdminPanelTitle ?? 'Super Admin')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              lang.superAdminRequiresLargeScreen ??
                  'Super Admin panel requires tablet/desktop.',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Account-level gating
    if (!isSuperAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.superAdminPanelTitle ?? 'Super Admin')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              lang.largeWebViewNotSupportedForAccount ??
                  'This screen is not supported for your account.',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final controller = context.watch<CommunityController>();

    return Scaffold(
      appBar: AppBar(title: Text(lang.superAdminPanelTitle ?? 'Super Admin')),
      floatingActionButton: FloatingActionButton(
        onPressed: user == null
            ? null
            : () => _showCreateCommunityDialog(
                context: context,
                createdBy: user.id,
              ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Community>>(
        stream: controller.service.streamCommunities(includeArchived: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                lang.communitiesEmptyTitle ?? 'No communities yet',
                style: theme.textTheme.titleLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = items[i];
              final isArchived = c.status == 'archived';
              return Card(
                child: ListTile(
                  onTap: () => context.go('/${AppRoutes.communities}/${c.id}'),
                  leading: CircleAvatar(
                    backgroundColor: isArchived
                        ? theme.colorScheme.surfaceContainerHighest
                        : theme.colorScheme.primaryContainer,
                    foregroundColor: isArchived
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onPrimaryContainer,
                    child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(c.name),
                  subtitle: Text(
                    isArchived
                        ? (lang.superAdminArchivedChip ?? 'Archived')
                        : (lang.superAdminActiveChip ?? 'Active'),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        tooltip: lang.superAdminManage ?? 'Manage',
                        icon: const Icon(Icons.manage_accounts_outlined),
                        onPressed: () =>
                            context.go('/${AppRoutes.communities}/${c.id}'),
                      ),
                      IconButton(
                        tooltip: lang.show ?? 'Show',
                        onPressed: () => _showEditCommunityDialog(
                          context: context,
                          community: c,
                        ),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: lang.superAdminArchive ?? 'Archive',
                        onPressed: isArchived
                            ? null
                            : () => _confirmArchive(
                                context: context,
                                community: c,
                              ),
                        icon: const Icon(Icons.archive_outlined),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
