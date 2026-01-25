import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/features/community/controllers/community_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/controllers.dart';
import '../../../core/localization/lang/localization.dart';
import '../../../core/routing/page_route.dart';
import '../../auth/controllers/controllers.dart';
import '../models/models.dart';

class CommunitiesPage extends StatelessWidget {
  const CommunitiesPage({super.key});

  Future<void> _showJoinConfirmDialog({
    required BuildContext context,
    required Localization lang,
    required VoidCallback onConfirm,
    required String communityName,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.communitiesJoinTitle ?? 'Join community'),
        content: Text(
          (lang.communitiesJoinDescription ?? 'Request to join {name}?')
              .replaceAll('{name}', communityName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(lang.close ?? 'Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(lang.continueText ?? 'Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _showInviteCodeDialog({
    required BuildContext context,
    required Localization lang,
    required CommunityController controller,
    required String userId,
  }) async {
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final res = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.communitiesEnterInviteCode ?? 'Enter invitation code'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: codeController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: lang.communitiesInviteCodeLabel ?? 'Code',
              border: const OutlineInputBorder(),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return lang.communitiesInviteCodeRequired ?? 'Code is required';
              }
              if (v.trim().length < 4) {
                return lang.communitiesInviteCodeInvalid ?? 'Invalid code';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(lang.close ?? 'Close'),
          ),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.of(
                context,
              ).pop(codeController.text.trim().toUpperCase());
            },
            child: Text(lang.continueText ?? 'Continue'),
          ),
        ],
      ),
    );

    codeController.dispose();
    if (res == null) return;

    final communityId = await controller.redeemCode(userId: userId, code: res);
    if (!context.mounted) return;

    if (communityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.communitiesInviteRedeemFailed ?? 'Invalid or expired code',
          ),
        ),
      );
      return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang.communitiesInviteRedeemSuccess ?? 'Joined community',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();
    final userId = context.select<UserController, String>(
      (c) => c.getCurrentUserID,
    );
    final controller = context.watch<CommunityController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: lang.back ?? 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.goToHome(context),
        ),
        title: Text(lang.communitiesTitle ?? 'Communities'),
        actions: [
          IconButton(
            tooltip: lang.communitiesEnterInviteCode ?? 'Enter invitation code',
            onPressed: userId == '0'
                ? null
                : () => _showInviteCodeDialog(
                    context: context,
                    lang: lang,
                    controller: controller,
                    userId: userId,
                  ),
            icon: const Icon(Icons.qr_code_2),
          ),
        ],
      ),
      body: StreamBuilder<List<Community>>(
        stream: controller.service.streamCommunities(includeArchived: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const _CommunitySkeletonCard(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang.somethingWentWrong ?? 'Something went wrong',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final communities = snapshot.data ?? const [];
          if (communities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang.communitiesEmptyTitle ?? 'No communities yet',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.communitiesEmptyDescription ??
                          'Communities will appear here.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: communities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = communities[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(c.name, style: theme.textTheme.titleMedium),
                  subtitle: Text(
                    c.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: StreamBuilder<CommunityMember?>(
                    stream: controller.service.streamMyMembership(
                      communityId: c.id,
                      userId: userId,
                    ),
                    builder: (context, memSnap) {
                      final m = memSnap.data;
                      final status = m?.status;
                      if (status == 'active') {
                        return Chip(
                          label: Text(lang.communitiesMemberChip ?? 'Member'),
                        );
                      }
                      if (status == 'pending') {
                        return Chip(
                          label: Text(lang.communitiesPendingChip ?? 'Pending'),
                        );
                      }
                      return FilledButton(
                        onPressed: userId == '0'
                            ? null
                            : () => _showJoinConfirmDialog(
                                context: context,
                                lang: lang,
                                communityName: c.name,
                                onConfirm: () async {
                                  await controller.requestJoin(
                                    communityId: c.id,
                                    userId: userId,
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        lang.communitiesJoinRequested ??
                                            'Join request sent',
                                      ),
                                    ),
                                  );
                                },
                              ),
                        child: Text(lang.communitiesJoinButton ?? 'Join'),
                      );
                    },
                  ),
                  onTap: () {
                    context.go('/${AppRoutes.communities}/${c.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CommunitySkeletonCard extends StatelessWidget {
  const _CommunitySkeletonCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme.surfaceContainerHighest;
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: c),
        title: Container(height: 14, width: 120, color: c),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(height: 12, width: 200, color: c),
        ),
      ),
    );
  }
}
