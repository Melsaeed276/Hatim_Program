import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequest {
  final String id;
  final String userId;
  final String status; // pending | approved | rejected
  final DateTime? createdAt;
  final String? processedBy;
  final DateTime? processedAt;

  const JoinRequest({
    required this.id,
    required this.userId,
    required this.status,
    this.createdAt,
    this.processedBy,
    this.processedAt,
  });

  factory JoinRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return JoinRequest(
      id: doc.id,
      userId: (data['userId'] ?? '').toString(),
      status: (data['status'] ?? 'pending').toString(),
      createdAt: _dateTimeFromAny(data['createdAt']),
      processedBy: data['processedBy']?.toString(),
      processedAt: _dateTimeFromAny(data['processedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'status': status,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (processedBy != null) 'processedBy': processedBy,
      if (processedAt != null) 'processedAt': Timestamp.fromDate(processedAt!),
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

