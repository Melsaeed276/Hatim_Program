class CommunityPermission {
  static const canCreateProgram = 'canCreateProgram';
  static const canManagePrograms = 'canManagePrograms';
  static const canSendNotification = 'canSendNotification';
  static const canManageMembers = 'canManageMembers';
  static const canEditCommunity = 'canEditCommunity';

  static const all = <String>[
    canCreateProgram,
    canManagePrograms,
    canSendNotification,
    canManageMembers,
    canEditCommunity,
  ];
}

bool hasCommunityPermission(List<String> permissions, String permission) {
  return permissions.contains(permission);
}

