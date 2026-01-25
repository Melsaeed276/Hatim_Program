import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hatim_program/features/community/models/community_status.dart';



class Community {
  final String id;
  final String name;
  final String description;
  final CommunityStatus status;
  final String? logoUrl;
  final String? createdCountry; // ISO 3166-1 alpha-2 recommended (e.g., TR, SA)
  final List<String> allowedCountries; // empty => open for all
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.logoUrl,
    this.createdCountry,
    this.allowedCountries = const <String>[],
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory Community.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Community(
      id: doc.id,
      name: ((data['name'] ?? '').toString().trim().isEmpty)
          ? 'Unnamed community'
          : (data['name'] ?? '').toString().trim(),
      description: (data['description'] ?? '').toString(),
      status: CommunityStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'active'),
        orElse: () => CommunityStatus.active,
      ),
      logoUrl: data['logoUrl']?.toString(),
      createdCountry: data['createdCountry']?.toString(),
      allowedCountries: (data['allowedCountries'] as List?)
              ?.map((e) => e.toString())
              .where((c) => c.trim().isNotEmpty)
              .toList() ??
          const <String>[],
      createdAt: _dateTimeFromAny(data['createdAt']),
      updatedAt: _dateTimeFromAny(data['updatedAt']),
      createdBy: data['createdBy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'status': status.name,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (createdCountry != null) 'createdCountry': createdCountry,
      if (allowedCountries.isNotEmpty) 'allowedCountries': allowedCountries,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (createdBy != null) 'createdBy': createdBy,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Community &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.status == status &&
        other.logoUrl == logoUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        status,
        logoUrl,
        createdAt,
        updatedAt,
        createdBy,
      );

  @override
  String toString() {
    return 'Community(id: $id, name: $name, status: ${status.name})';
  }
}

DateTime? _dateTimeFromAny(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}
