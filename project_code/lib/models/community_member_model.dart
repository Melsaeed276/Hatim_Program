enum CommunityRole {
  admin,
  member,
}

class CommunityAdminPermissions {
  bool canCreateHatim;
  bool canCreateZikir;
  bool canSendNotifications;

  CommunityAdminPermissions({
    this.canCreateHatim = false,
    this.canCreateZikir = false,
    this.canSendNotifications = false,
  });

  factory CommunityAdminPermissions.fromJson(Map<String, dynamic> json) {
    return CommunityAdminPermissions(
      canCreateHatim: json['canCreateHatim'] ?? false,
      canCreateZikir: json['canCreateZikir'] ?? false,
      canSendNotifications: json['canSendNotifications'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canCreateHatim': canCreateHatim,
      'canCreateZikir': canCreateZikir,
      'canSendNotifications': canSendNotifications,
    };
  }
}

class CommunityMemberModel {
  final String userId;
  final String communityId;
  CommunityRole role;
  CommunityAdminPermissions? permissions;

  CommunityMemberModel({
    required this.userId,
    required this.communityId,
    this.role = CommunityRole.member,
    this.permissions,
  });

  factory CommunityMemberModel.fromJson(Map<String, dynamic> json) {
    return CommunityMemberModel(
      userId: json['userId'],
      communityId: json['communityId'],
      role: CommunityRole.values[json['role'] ?? CommunityRole.member.index],
      permissions: json['permissions'] != null
          ? CommunityAdminPermissions.fromJson(json['permissions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'communityId': communityId,
      'role': role.index,
      'permissions': permissions?.toJson(),
    };
  }
}
