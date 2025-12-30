class ReferenceCodeModel {
  final String code;
  final String adminId;
  final DateTime createdAt;

  ReferenceCodeModel({
    required this.code,
    required this.adminId,
    required this.createdAt,
  });

  ReferenceCodeModel.fromJson(Map<String, dynamic> json)
    : code = json['code'],
      adminId = json['adminId'],
      createdAt = DateTime.parse(json['createdAt']);

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'adminId': adminId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
