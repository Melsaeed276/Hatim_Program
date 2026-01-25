///User Model
///
/// Each user will have a phone number and a name
/// Each user may belong to one or more groups
library;

class UserModel {
  late final String id;
  final String name;
  String phoneNumber;
  final bool isAdmin;
  final bool isSuperAdmin;
  final String? adminPassword; // Password for admin verification
  String? password; // Password for regular user login
  int totalCompletedChapters = 0; // Total completed chapters, default 0
  double score = 0; // User score, default 0
  String? joinedByAdminId; // ID of the admin who provided the reference code
  DateTime? joinedAt; // Date when the user joined via reference code
  // map of groupsID and int of the current chapter
  List<String> groups = [];

  UserModel({
    required this.name,
    required this.phoneNumber,
    this.isAdmin = false,
    this.isSuperAdmin = false,
    this.adminPassword,
    this.password,
    this.totalCompletedChapters = 0,
    this.score = 0.0,
    this.joinedByAdminId,
    this.joinedAt,
  }) {
    id = processPhoneNumber(phoneNumber);
  }

  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      phoneNumber = json['phoneNumber'],
      isAdmin = json['isAdmin'] ?? false,
      isSuperAdmin = json['isSuperAdmin'] ?? false,
      adminPassword = json['adminPassword']?.toString(),
      password = json['password']?.toString(),
      totalCompletedChapters = json['totalCompletedChapters'] ?? 0,
      score = (json['score'] ?? 0).toDouble(),
      joinedByAdminId = json['joinedByAdminId']?.toString(),
      joinedAt = json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : null,
      groups = List<String>.from(json['groups'].map((x) => x.toString()));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = processPhoneNumber(phoneNumber);
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['isAdmin'] = isAdmin;
    data['isSuperAdmin'] = isSuperAdmin;
    if (adminPassword != null) {
      data['adminPassword'] = adminPassword;
    }
    if (password != null) {
      data['password'] = password;
    }
    data['totalCompletedChapters'] = totalCompletedChapters;
    data['score'] = score;
    if (joinedByAdminId != null) {
      data['joinedByAdminId'] = joinedByAdminId;
    }
    if (joinedAt != null) {
      data['joinedAt'] = joinedAt!.toIso8601String();
    }
    data['groups'] = groups;
    return data;
  }

  // process phone number static function
  static String processPhoneNumber(String phoneNumber) {
    // Remove all spaces, "+", "-" and non-digits
    String processedNumber = phoneNumber.replaceAll(RegExp(r"\D"), "");

    // Remove leading "0" if it exists
    if (processedNumber.startsWith("0")) {
      processedNumber = processedNumber.substring(1);
    }

    return processedNumber;
  }

  // is phone number the same
  bool isEqual(String phoneNumber) {
    if (this.phoneNumber == phoneNumber) {
      return true;
    }
    return false;
  }

  //if the current user has group
  bool isInTheGroups(String groupID) {
    if (groups.contains(groupID)) {
      return true;
    }
    return false;
  }

  bool hasGroup(String groupID) {
    if (groups.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
