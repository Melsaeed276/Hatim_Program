import 'package:cloud_firestore/cloud_firestore.dart';

class InviteCode {
  final String id; // can be the code itself
  final String code;
  final bool active;
  final int uses;
  final int? maxUses;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? expiresAt;

  const InviteCode({
    required this.id,
    required this.code,
    required this.active,
    required this.uses,
    this.maxUses,
    this.createdAt,
    this.createdBy,
    this.expiresAt,
  });

  factory InviteCode.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return InviteCode(
      id: doc.id,
      code: (data['code'] ?? doc.id).toString(),
      active: (data['active'] ?? true) == true,
      uses: (data['uses'] ?? 0) as int,
      maxUses: data['maxUses'] as int?,
      createdAt: _dateTimeFromAny(data['createdAt']),
      createdBy: data['createdBy']?.toString(),
      expiresAt: _dateTimeFromAny(data['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'active': active,
      'uses': uses,
      if (maxUses != null) 'maxUses': maxUses,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (createdBy != null) 'createdBy': createdBy,
      if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt!),
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

