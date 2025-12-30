import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/zikir_model.dart';

import 'hatim_model.dart';

class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String createdBy; // SuperAdmin ID
  final List<CommunityMemberModel> members;
  final List<HatimModel> hatimPrograms;
  final List<ZikirModel> zikirs;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    this.members = const [],
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
      hatimPrograms: (json['hatimPrograms'] as List<dynamic>?)
              ?.map((e) => HatimModel.fromJson(e as Map<String, dynamic>))
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
      'hatimPrograms': hatimPrograms.map((e) => e.toJson()).toList(),
      'zikirs': zikirs.map((e) => e.toJson()).toList(),
    };
  }
}
