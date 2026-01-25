import 'package:flutter/material.dart';
import 'package:hatim_program/features/community/controllers/community_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/controllers.dart';
import '../../auth/controllers/controllers.dart';
import '../models/models.dart';

class CommunityDetailPage extends StatelessWidget {
  final String communityId;
  const CommunityDetailPage({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();
    final userId = context.select<UserController, String>(
      (c) => c.getCurrentUserID,
    );
    final controller = context.watch<CommunityController>();
    final user = context.watch<UserController>().userModel;
    final isSuperAdmin = user?.isSuperAdmin ?? false;

    return StreamBuilder<Community?>(
      stream: controller.service
          .streamCommunities(includeArchived: true)
          .map(
            (list) => list
                .where((c) => c.id == communityId)
                .cast<Community?>()
                .firstOrNull,
          ),
      builder: (context, snapshot) {
        final community = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              community?.name ?? (lang.communitiesTitle ?? 'Communities'),
            ),
          ),
          body: community == null
              ? Center(
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
                          lang.noData ?? 'No Data',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                )
              : StreamBuilder<CommunityMember?>(
                  stream: controller.service.streamMyMembership(
                    communityId: communityId,
                    userId: userId,
                  ),
                  builder: (context, memSnap) {
                    final member = memSnap.data;
                    final isMember = member?.status == 'active' || isSuperAdmin;
                    final canManageMembers =
                        isSuperAdmin ||
                        controller.hasPermission(
                          member,
                          CommunityPermission.canManageMembers,
                        );
                    final canEditCommunity =
                        isSuperAdmin ||
                        controller.hasPermission(
                          member,
                          CommunityPermission.canEditCommunity,
                        );

                    final tabs = <Tab>[
                      Tab(text: lang.communitiesProgramsTab ?? 'Programs'),
                      Tab(text: lang.communitiesMembersTab ?? 'Members'),
                      if (canManageMembers)
                        Tab(
                          text:
                              lang.communitiesJoinRequestsTab ??
                              'Join Requests',
                        ),
                      if (canEditCommunity)
                        Tab(text: lang.communitiesSettingsTab ?? 'Settings'),
                    ];

                    return DefaultTabController(
                      length: tabs.length,
                      child: Column(
                        children: [
                          Material(
                            color: theme.colorScheme.surface,
                            child: TabBar(tabs: tabs, isScrollable: true),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _ProgramsTab(
                                  communityId: communityId,
                                  isMember: isMember,
                                ),
                                _MembersTab(communityId: communityId),
                                if (canManageMembers)
                                  _JoinRequestsTab(
                                    communityId: communityId,
                                    adminId: userId,
                                  ),
                                if (canEditCommunity)
                                  _SettingsTab(communityId: communityId),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ProgramsTab extends StatelessWidget {
  final String communityId;
  final bool isMember;
  const _ProgramsTab({required this.communityId, required this.isMember});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();
    final controller = context.watch<CommunityController>();

    if (!isMember) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                lang.communitiesMembersOnlyMessage ??
                    'Join this community to view programs.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<List<CommunityProgram>>(
      stream: controller.service.streamPrograms(communityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lang.communitiesNoProgramsTitle ?? 'No programs yet',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final p = items[i];
            return Card(
              child: ListTile(
                leading: Icon(
                  Icons.event_note,
                  color: theme.colorScheme.primary,
                ),
                title: Text(p.displayTitle),
                subtitle: Text(p.type.name),
              ),
            );
          },
        );
      },
    );
  }
}

class _MembersTab extends StatelessWidget {
  final String communityId;
  const _MembersTab({required this.communityId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CommunityController>();
    final lang = context.watch<LocalizationController>().getLanguage();

    return StreamBuilder<List<CommunityMember>>(
      stream: controller.service.streamMembers(communityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final members = snapshot.data ?? const [];
        if (members.isEmpty) {
          return Center(
            child: Text(
              lang.noData ?? 'No Data',
              style: theme.textTheme.bodyLarge,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final m = members[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  child: Text(
                    m.userId.isNotEmpty ? m.userId[0].toUpperCase() : '?',
                  ),
                ),
                title: Text(m.userId),
                subtitle: Text(m.status.name),
              ),
            );
          },
        );
      },
    );
  }
}

class _JoinRequestsTab extends StatelessWidget {
  final String communityId;
  final String adminId;
  const _JoinRequestsTab({required this.communityId, required this.adminId});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CommunityController>();
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();

    return StreamBuilder<List<JoinRequest>>(
      stream: controller.service.streamJoinRequests(communityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = (snapshot.data ?? const [])
            .where((r) => r.status == 'pending')
            .toList();
        if (items.isEmpty) {
          return Center(
            child: Text(
              lang.communitiesNoJoinRequests ?? 'No pending requests',
              style: theme.textTheme.bodyLarge,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final r = items[i];
            return Card(
              child: ListTile(
                title: Text(r.userId),
                subtitle: Text(lang.communitiesJoinRequestPending ?? 'Pending'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              await controller.rejectJoin(
                                communityId: communityId,
                                requestId: r.id,
                                adminId: adminId,
                              );
                            },
                      child: Text(lang.communitiesReject ?? 'Reject'),
                    ),
                    FilledButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              await controller.approveJoin(
                                communityId: communityId,
                                requestId: r.id,
                                adminId: adminId,
                              );
                            },
                      child: Text(lang.communitiesApprove ?? 'Approve'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final String communityId;
  const _SettingsTab({required this.communityId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              lang.communitiesSettingsTab ?? 'Settings',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
