

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/community_service.dart';

/// Repository layer between ViewModels and Services.
///
/// - ViewModels must call only this repo (never call services directly).
/// - Repo performs basic input validation/normalization.
/// - Repo may coordinate multiple services in a single method (when needed).
/// - No local storage is used for Community yet.
class CommunityRepo {
  final CommunityService _service;

  CommunityRepo({CommunityService? service})
      : _service = service ?? CommunityService();

  // -----------------------------
  // Reads / Streams
  // -----------------------------

  Stream<List<Community>> streamCommunities({bool includeArchived = false}) {
    return _service.streamCommunities(includeArchived: includeArchived);
  }

  Future<Community?> getCommunity(String communityId) {
    _requireId(communityId, name: 'communityId');
    return _service.getCommunity(communityId);
  }

  Stream<CommunityMember?> streamMyMembership({
    required String communityId,
    required String userId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(userId, name: 'userId');
    return _service.streamMyMembership(communityId: communityId, userId: userId);
  }

  Stream<List<CommunityMember>> streamMembers(String communityId) {
    _requireId(communityId, name: 'communityId');
    return _service.streamMembers(communityId);
  }

  Stream<List<CommunityMembershipRef>> streamMyMembershipRefsFromUserIndex(
    String userId,
  ) {
    _requireId(userId, name: 'userId');
    return _service.streamMyMembershipRefsFromUserIndex(userId);
  }

  Stream<List<JoinRequest>> streamJoinRequests(String communityId) {
    _requireId(communityId, name: 'communityId');
    return _service.streamJoinRequests(communityId);
  }

  Stream<List<CommunityProgram>> streamPrograms(String communityId) {
    _requireId(communityId, name: 'communityId');
    return _service.streamPrograms(communityId);
  }

  Future<List<CommunityProgram>> getMyProgramsAcrossCommunities({
    required String userId,
  }) {
    _requireId(userId, name: 'userId');
    return _service.getMyProgramsAcrossCommunities(userId: userId);
  }

  Stream<List<String>> streamProgramParticipants({
    required String communityId,
    required String programId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(programId, name: 'programId');
    return _service.streamProgramParticipants(
      communityId: communityId,
      programId: programId,
    );
  }

  Stream<int> streamProgramParticipantCount({
    required String communityId,
    required String programId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(programId, name: 'programId');
    return _service.streamProgramParticipantCount(
      communityId: communityId,
      programId: programId,
    );
  }

  // -----------------------------
  // Community (writes)
  // -----------------------------

  Future<String> createCommunity({
    required String name,
    required String description,
    String? logoUrl,
    String? createdCountry,
    List<String> allowedCountries = const <String>[],
    required String createdBy,
  }) {
    _requireId(createdBy, name: 'createdBy');

    final n = name.trim();
    if (n.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Community name cannot be empty');
    }

    final d = description.trim();
    if (d.isEmpty) {
      throw ArgumentError.value(
        description,
        'description',
        'Community description cannot be empty',
      );
    }

    final cc = _normalizeCountryCode(createdCountry);
    final allow = _normalizeCountryList(allowedCountries);

    return _service.createCommunity(
      name: n,
      description: d,
      logoUrl: logoUrl?.trim().isEmpty == true ? null : logoUrl,
      createdCountry: cc,
      allowedCountries: allow,
      createdBy: createdBy,
    );
  }

  Future<void> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? status,
    String? logoUrl,
    String? createdCountry,
    List<String>? allowedCountries,
  }) {
    _requireId(communityId, name: 'communityId');

    // Require at least one meaningful update
    final hasAny =
        name != null ||
        description != null ||
        status != null ||
        logoUrl != null ||
        createdCountry != null ||
        allowedCountries != null;
    if (!hasAny) return Future.value();

    final n = name?.trim();
    if (name != null && (n == null || n.isEmpty)) {
      throw ArgumentError.value(name, 'name', 'Community name cannot be empty');
    }

    final d = description?.trim();
    if (description != null && (d == null || d.isEmpty)) {
      throw ArgumentError.value(
        description,
        'description',
        'Community description cannot be empty',
      );
    }

    final cc = _normalizeCountryCode(createdCountry);
    final allow = allowedCountries == null
        ? null
        : _normalizeCountryList(allowedCountries);

    return _service.updateCommunity(
      communityId: communityId,
      name: n,
      description: d,
      status: status,
      logoUrl: logoUrl?.trim().isEmpty == true ? null : logoUrl,
      createdCountry: cc,
      allowedCountries: allow,
    );
  }

  Future<void> archiveCommunity(String communityId) {
    _requireId(communityId, name: 'communityId');
    return _service.archiveCommunity(communityId);
  }

  // -----------------------------
  // Membership / Requests
  // -----------------------------

  Future<void> createJoinRequest({
    required String communityId,
    required String userId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(userId, name: 'userId');
    return _service.createJoinRequest(communityId: communityId, userId: userId);
  }

  Future<void> approveJoinRequest({
    required String communityId,
    required String requestId,
    required String adminId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(requestId, name: 'requestId');
    _requireId(adminId, name: 'adminId');
    return _service.approveJoinRequest(
      communityId: communityId,
      requestId: requestId,
      adminId: adminId,
    );
  }

  Future<void> rejectJoinRequest({
    required String communityId,
    required String requestId,
    required String adminId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(requestId, name: 'requestId');
    _requireId(adminId, name: 'adminId');
    return _service.rejectJoinRequest(
      communityId: communityId,
      requestId: requestId,
      adminId: adminId,
    );
  }

  Future<void> leaveCommunity({
    required String communityId,
    required String userId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(userId, name: 'userId');
    return _service.leaveCommunity(communityId: communityId, userId: userId);
  }

  Future<void> removeMember({
    required String communityId,
    required String targetUserId,
    required String adminId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(targetUserId, name: 'targetUserId');
    _requireId(adminId, name: 'adminId');
    return _service.removeMember(
      communityId: communityId,
      targetUserId: targetUserId,
      adminId: adminId,
    );
  }

  Future<void> setMemberPermissions({
    required String communityId,
    required String targetUserId,
    required List<String> permissions,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(targetUserId, name: 'targetUserId');

    final normalized = permissions
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toSet()
        .toList();

    return _service.setMemberPermissions(
      communityId: communityId,
      targetUserId: targetUserId,
      permissions: normalized,
    );
  }

  // -----------------------------
  // Invite codes
  // -----------------------------

  Future<String> createInviteCode({
    required String communityId,
    required String adminId,
    int length = 8,
    int? maxUses,
    DateTime? expiresAt,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(adminId, name: 'adminId');

    if (length < 4 || length > 32) {
      throw ArgumentError.value(length, 'length', 'Invite length must be 4..32');
    }

    if (maxUses != null && maxUses <= 0) {
      throw ArgumentError.value(maxUses, 'maxUses', 'maxUses must be > 0');
    }

    if (expiresAt != null && expiresAt.isBefore(DateTime.now())) {
      throw ArgumentError.value(expiresAt, 'expiresAt', 'expiresAt must be in the future');
    }

    return _service.createInviteCode(
      communityId: communityId,
      adminId: adminId,
      length: length,
      maxUses: maxUses,
      expiresAt: expiresAt,
    );
  }

  Future<String?> redeemInviteCode({
    required String userId,
    required String code,
  }) {
    _requireId(userId, name: 'userId');
    final c = code.trim();
    if (c.isEmpty) {
      throw ArgumentError.value(code, 'code', 'Invite code cannot be empty');
    }
    return _service.redeemInviteCode(userId: userId, code: c);
  }

  // -----------------------------
  // Programs
  // -----------------------------

  Future<String> createProgram({
    required String communityId,
    required CommunityProgramType type,
    required String programTitle,
    int? userLimit,
    required String createdBy,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(createdBy, name: 'createdBy');

    final t = programTitle.trim();
    if (t.isEmpty) {
      throw ArgumentError.value(programTitle, 'programTitle', 'Program title cannot be empty');
    }

    if (userLimit != null && userLimit < 0) {
      throw ArgumentError.value(userLimit, 'userLimit', 'userLimit cannot be negative');
    }

    return _service.createProgram(
      communityId: communityId,
      type: type,
      programTitle: t,
      userLimit: userLimit,
      createdBy: createdBy,
    );
  }

  Future<void> updateProgram({
    required String communityId,
    required String programId,
    String? programTitle,
    CommunityProgramType? type,
    int? userLimit,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(programId, name: 'programId');

    final hasAny = programTitle != null || type != null || userLimit != null;
    if (!hasAny) return Future.value();

    final t = programTitle?.trim();
    if (programTitle != null && (t == null || t.isEmpty)) {
      throw ArgumentError.value(programTitle, 'programTitle', 'Program title cannot be empty');
    }

    if (userLimit != null && userLimit < 0) {
      throw ArgumentError.value(userLimit, 'userLimit', 'userLimit cannot be negative');
    }

    return _service.updateProgram(
      communityId: communityId,
      programId: programId,
      programTitle: t,
      type: type,
      userLimit: userLimit,
    );
  }

  Future<void> joinProgram({
    required String communityId,
    required String programId,
    required String userId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(programId, name: 'programId');
    _requireId(userId, name: 'userId');
    return _service.joinProgram(
      communityId: communityId,
      programId: programId,
      userId: userId,
    );
  }

  Future<void> leaveProgram({
    required String communityId,
    required String programId,
    required String userId,
  }) {
    _requireId(communityId, name: 'communityId');
    _requireId(programId, name: 'programId');
    _requireId(userId, name: 'userId');
    return _service.leaveProgram(
      communityId: communityId,
      programId: programId,
      userId: userId,
    );
  }

  // -----------------------------
  // Validation / Normalization helpers
  // -----------------------------

  void _requireId(String value, {required String name}) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, name, '$name cannot be empty');
    }
  }

  /// Normalize ISO 3166-1 alpha-2 country code.
  /// Returns null if input is null or blank.
  String? _normalizeCountryCode(String? code) {
    if (code == null) return null;
    final c = code.trim().toUpperCase();
    if (c.isEmpty) return null;
    if (c.length != 2) {
      throw ArgumentError.value(code, 'country', 'Country code must be 2 letters (ISO alpha-2)');
    }
    // Basic sanity: only A-Z
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(c)) {
      throw ArgumentError.value(code, 'country', 'Country code must be A-Z letters (ISO alpha-2)');
    }
    return c;
  }

  /// Normalize allowedCountries list: trim, uppercase, remove empties and duplicates.
  List<String> _normalizeCountryList(List<String> codes) {
    final set = <String>{};
    for (final raw in codes) {
      final c = _normalizeCountryCode(raw);
      if (c != null) set.add(c);
    }
    return set.toList()..sort();
  }
}

/// Utility: list equality for small lists without extra deps.
bool listEqualsUnordered<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  final aa = List<T>.from(a)..sort((x, y) => x.hashCode.compareTo(y.hashCode));
  final bb = List<T>.from(b)..sort((x, y) => x.hashCode.compareTo(y.hashCode));
  return listEquals(aa, bb);
}