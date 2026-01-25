import 'package:cloud_firestore/cloud_firestore.dart';

enum CommunityMemberStatus { active, pending, left, removed }

enum CommunityJoinMethod { request, invitation }

class CommunityMember {
  final String userId;
  final CommunityMemberStatus status;
  final DateTime? joinedAt;
  final CommunityJoinMethod? joinMethod;
  final String? approvedBy;
  final String? invitedBy;
  final double score;
  final bool activeUser;
  final List<String> permissions;

  const CommunityMember({
    required this.userId,
    required this.status,
    this.joinedAt,
    this.joinMethod,
    this.approvedBy,
    this.invitedBy,
    this.score = 0,
    this.activeUser = true,
    this.permissions = const [],
  });

  bool get isActive => status == CommunityMemberStatus.active;
  bool get isPending => status == CommunityMemberStatus.pending;
  bool get isRemoved => status == CommunityMemberStatus.removed;
  bool get hasLeft => status == CommunityMemberStatus.left;

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  factory CommunityMember.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return CommunityMember(
      userId: doc.id,
      status: CommunityMemberStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => CommunityMemberStatus.pending,
      ),
      joinedAt: _dateTimeFromAny(data['joinedAt']),
      joinMethod: data['joinMethod'] == null
          ? null
          : CommunityJoinMethod.values.firstWhere(
              (e) => e.name == data['joinMethod'],
              orElse: () => CommunityJoinMethod.request,
            ),
      approvedBy: data['approvedBy']?.toString(),
      invitedBy: data['invitedBy']?.toString(),
      score: (data['score'] ?? 0).toDouble(),
      activeUser: (data['activeUser'] ?? true) == true,
      permissions: (data['permissions'] is Iterable)
          ? List<String>.from((data['permissions'] as Iterable).map((e) => e.toString()))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status.name,
      if (joinedAt != null) 'joinedAt': Timestamp.fromDate(joinedAt!),
      if (joinMethod != null) 'joinMethod': joinMethod!.name,
      if (approvedBy != null) 'approvedBy': approvedBy,
      if (invitedBy != null) 'invitedBy': invitedBy,
      'score': score,
      'activeUser': activeUser,
      'permissions': permissions,
    };
  }
}

DateTime? _dateTimeFromAny(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
