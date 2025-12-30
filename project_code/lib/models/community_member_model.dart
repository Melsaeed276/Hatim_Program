// 1. Enum for the user's role within a community
enum CommunityRole {
  admin,
  member,
}

// 2. A dedicated class for admin permissions
// This makes it easy to add new permissions in the future.
class CommunityAdminPermissions {
  final bool canCreateHatim;
  final bool canCreateZikir;
  final bool canSendNotifications;

  CommunityAdminPermissions({
    this.canCreateHatim = false,
    this.canCreateZikir = false,
    this.canSendNotifications = false,
  });

  // Factory constructor for JSON deserialization
  factory CommunityAdminPermissions.fromJson(Map<String, dynamic> json) {
    return CommunityAdminPermissions(
      canCreateHatim: json['canCreateHatim'] ?? false,
      canCreateZikir: json['canCreateZikir'] ?? false,
      canSendNotifications: json['canSendNotifications'] ?? false,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'canCreateHatim': canCreateHatim,
      'canCreateZikir': canCreateZikir,
      'canSendNotifications': canSendNotifications,
    };
  }
}

// 3. The main model to link a user to a community
class CommunityMemberModel {
  final String userId;
  final String communityId;
  final CommunityRole role;
  final CommunityAdminPermissions? permissions; // Nullable for non-admins

  CommunityMemberModel({
    required this.userId,
    required this.communityId,
    this.role = CommunityRole.member,
    this.permissions, // Only admins will have this object
  });

  // Factory constructor for JSON deserialization
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

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'communityId': communityId,
      'role': role.index,
      'permissions': permissions?.toJson(),
    };
  }
}
