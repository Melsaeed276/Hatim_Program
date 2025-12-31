import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/group_model.dart';
import 'package:hatim_program/models/zikir_model.dart';

class CommunityModel {
  final String id;
  String name;
  final String description;
  final String createdBy; // SuperAdmin ID
  final List<CommunityMemberModel> members;
  final List<String> pendingMembers; // List of user IDs
  final List<GroupModel> hatimPrograms;
  final List<ZikirModel> zikirs;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    this.members = const [],
    this.pendingMembers = const [],
    this.hatimPrograms = const [],
    this.zikirs = const [],
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['createdBy'],
      members: (json['members'] as List<dynamic>?)
              ?.map((e) =>
                  CommunityMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pendingMembers: List<String>.from(json['pendingMembers'] ?? []),
      hatimPrograms: (json['hatimPrograms'] as List<dynamic>?)
              ?.map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      zikirs: (json['zikirs'] as List<dynamic>?)
              ?.map((e) => ZikirModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'members': members.map((e) => e.toJson()).toList(),
      'pendingMembers': pendingMembers,
      'hatimPrograms': hatimPrograms.map((e) => e.toJson()).toList(),
      'zikirs': zikirs.map((e) => e.toJson()).toList(),
    };
  }
}
