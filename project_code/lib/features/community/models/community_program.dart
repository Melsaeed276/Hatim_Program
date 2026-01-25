
import 'package:cloud_firestore/cloud_firestore.dart';

enum CommunityProgramType { quran, zikir, event }

class CommunityProgram {
  final String id;
  final String communityId;
  final CommunityProgramType type;
  final String programTitle;
  final int? userLimit; // null or 0 => no limit
  final DateTime? createdAt;
  final String? createdBy;

  const CommunityProgram({
    required this.id,
    required this.communityId,
    required this.type,
    required this.programTitle,
    this.userLimit,
    this.createdAt,
    this.createdBy,
  });

  String get displayTitle =>
      programTitle.trim().isEmpty ? 'Untitled program' : programTitle.trim();

  CommunityProgram copyWith({
    String? communityId,
    CommunityProgramType? type,
    String? programTitle,
    int? userLimit,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return CommunityProgram(
      id: id,
      communityId: communityId ?? this.communityId,
      type: type ?? this.type,
      programTitle: programTitle ?? this.programTitle,
      userLimit: userLimit ?? this.userLimit,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  factory CommunityProgram.fromDoc(
    String communityId,
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return CommunityProgram(
      id: doc.id,
      communityId: communityId,
      type: _programTypeFromAny(data['type']),
      programTitle: (data['programTitle'] ?? data['title'] ?? '').toString(),
      userLimit: _intFromAny(data['userLimit']),
      createdAt: _dateTimeFromAny(data['createdAt']),
      createdBy: data['createdBy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'communityId': communityId,
      'type': type.name,
      'programTitle': programTitle,
      if (userLimit != null) 'userLimit': userLimit,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (createdBy != null) 'createdBy': createdBy,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommunityProgram &&
        other.id == id &&
        other.communityId == communityId &&
        other.type == type &&
        other.programTitle == programTitle &&
        other.userLimit == userLimit &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode => Object.hash(
        id,
        communityId,
        type,
        programTitle,
        userLimit,
        createdAt,
        createdBy,
      );

  @override
  String toString() {
    return 'CommunityProgram(id: $id, communityId: $communityId, type: ${type.name}, programTitle: $programTitle, userLimit: $userLimit)';
  }
}

CommunityProgramType _programTypeFromAny(dynamic value) {
  final raw = (value ?? 'quran').toString().trim().toLowerCase();
  for (final t in CommunityProgramType.values) {
    if (t.name == raw) return t;
  }
  return CommunityProgramType.quran;
}

int? _intFromAny(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  final s = value.toString().trim();
  if (s.isEmpty) return null;
  return int.tryParse(s);
}

DateTime? _dateTimeFromAny(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

