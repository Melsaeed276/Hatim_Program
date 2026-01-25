import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class CommunityService {
  final FirebaseFirestore _db;

  CommunityService({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _communities =>
      _db.collection('communities');

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  /// Stream all communities (public). Optionally filter archived out.
  Stream<List<Community>> streamCommunities({bool includeArchived = false}) {
    Query<Map<String, dynamic>> q = _communities;
    if (!includeArchived) {
      q = q.where('status', isEqualTo: 'active');
    }
    return q.snapshots().map(
      (snap) => snap.docs.map(Community.fromDoc).toList(),
    );
  }

  Future<Community?> getCommunity(String communityId) async {
    final doc = await _communities.doc(communityId).get();
    if (!doc.exists) return null;
    return Community.fromDoc(doc);
  }

  Stream<CommunityMember?> streamMyMembership({
    required String communityId,
    required String userId,
  }) {
    return _communities
        .doc(communityId)
        .collection('members')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? CommunityMember.fromDoc(doc) : null);
  }

  Stream<List<CommunityMember>> streamMembers(String communityId) {
    return _communities
        .doc(communityId)
        .collection('members')
        .snapshots()
        .map((snap) => snap.docs.map(CommunityMember.fromDoc).toList());
  }

  Stream<List<CommunityMember>> streamMyMemberships(String userId) {
    // Note: When using collectionGroup with documentId filter, we need to provide
    // the full document path. However, since we don't know all community IDs upfront,
    // we'll query all members and filter client-side.
    return _db
        .collectionGroup('members')
        .snapshots()
        .map(
          (snap) => snap.docs
              .where((doc) => doc.id == userId)
              .map(CommunityMember.fromDoc)
              .toList(),
        );
  }

  Stream<List<CommunityMembershipRef>> streamMyMembershipRefs(String userId) {
    // Note: When using collectionGroup with documentId filter, we need to provide
    // the full document path. However, since we don't know all community IDs upfront,
    // we'll query all members and filter client-side.
    return _db.collectionGroup('members').snapshots().map((snap) {
      return snap.docs.where((doc) => doc.id == userId).map((doc) {
        final communityId = doc.reference.parent.parent?.id ?? '';
        return CommunityMembershipRef(
          communityId: communityId,
          member: CommunityMember.fromDoc(doc),
        );
      }).toList();
    });
  }

  Stream<List<CommunityMembershipRef>> streamMyMembershipRefsFromUserIndex(
    String userId,
  ) {
    return _users.doc(userId).collection('memberships').snapshots().map((snap) {
      return snap.docs.map((d) {
        final communityId = d.id;
        final member = CommunityMember.fromDoc(d);
        return CommunityMembershipRef(communityId: communityId, member: member);
      }).toList();
    });
  }

  Stream<List<JoinRequest>> streamJoinRequests(String communityId) {
    return _communities
        .doc(communityId)
        .collection('joinRequests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(JoinRequest.fromDoc).toList());
  }

  Stream<List<CommunityProgram>> streamPrograms(String communityId) {
    return _communities
        .doc(communityId)
        .collection('programs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => CommunityProgram.fromDoc(communityId, d))
              .toList(),
        );
  }

  Future<List<CommunityProgram>> getMyProgramsAcrossCommunities({
    required String userId,
  }) async {
    final memSnap = await _users
        .doc(userId)
        .collection('memberships')
        .where('status', isEqualTo: 'active')
        .get();

    final communityIds = memSnap.docs.map((d) => d.id).toList();
    if (communityIds.isEmpty) return <CommunityProgram>[];

    final results = <CommunityProgram>[];

    // Firestore whereIn supports up to 10 values.
    for (var i = 0; i < communityIds.length; i += 10) {
      final chunk = communityIds.sublist(
        i,
        (i + 10 > communityIds.length) ? communityIds.length : (i + 10),
      );

      final q = await _db
          .collectionGroup('programs')
          .where('communityId', whereIn: chunk)
          .get();

      for (final d in q.docs) {
        // In collectionGroup, communityId should be stored, but we also infer it from path as a fallback.
        final inferredCommunityId = d.reference.parent.parent?.id ?? '';
        final cid = (d.data()['communityId'] ?? inferredCommunityId).toString();
        results.add(CommunityProgram.fromDoc(cid, d));
      }
    }

    // Client-side sort by createdAt if present.
    results.sort((a, b) {
      final aTs = (a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
      final bTs = (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
      return bTs.compareTo(aTs);
    });

    return results;
  }

  /// Super Admin: create a community.
  Future<String> createCommunity({
    required String name,
    required String description,
    String? logoUrl,
    String? createdCountry,
    List<String> allowedCountries = const <String>[],
    required String createdBy,
  }) async {
    final doc = _communities.doc();
    await doc.set(<String, dynamic>{
      'name': name,
      'description': description,
      'status': 'active',
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (createdCountry != null) 'createdCountry': createdCountry,
      if (allowedCountries.isNotEmpty) 'allowedCountries': allowedCountries,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });
    return doc.id;
  }

  /// Super Admin: edit community fields.
  Future<void> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? status,
    String? logoUrl,
    String? createdCountry,
    List<String>? allowedCountries,
  }) async {
    final patch = <String, dynamic>{};
    if (name != null) patch['name'] = name;
    if (description != null) patch['description'] = description;
    if (status != null) patch['status'] = status;
    if (logoUrl != null) patch['logoUrl'] = logoUrl;
    if (createdCountry != null) patch['createdCountry'] = createdCountry;
    if (allowedCountries != null) patch['allowedCountries'] = allowedCountries;
    patch['updatedAt'] = FieldValue.serverTimestamp();
    if (patch.isEmpty) return;
    await _communities.doc(communityId).update(patch);
  }

  Future<void> archiveCommunity(String communityId) async {
    await updateCommunity(communityId: communityId, status: 'archived');
  }

  /// Normal user: request to join (creates join request, and creates/updates member status to pending).
  Future<void> createJoinRequest({
    required String communityId,
    required String userId,
  }) async {
    final reqRef = _communities
        .doc(communityId)
        .collection('joinRequests')
        .doc();
    final memRef = _communities
        .doc(communityId)
        .collection('members')
        .doc(userId);

    await _db.runTransaction((tx) async {
      final existingMember = await tx.get(memRef);
      if (existingMember.exists) {
        final data = existingMember.data() as Map<String, dynamic>;
        final status = (data['status'] ?? '').toString();
        if (status == 'active' || status == 'pending') {
          return;
        }
      }

      tx.set(reqRef, <String, dynamic>{
        'userId': userId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.set(memRef, <String, dynamic>{
        'status': 'pending',
        'joinMethod': 'request',
        'activeUser': true,
        'permissions': <String>[],
        'score': 0.0,
      }, SetOptions(merge: true));

      await _upsertUserMembershipIndex(
        tx: tx,
        userId: userId,
        communityId: communityId,
        data: <String, dynamic>{
          'communityId': communityId,
          'status': 'pending',
          'joinMethod': 'request',
          'activeUser': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    });
  }

  /// Admin: approve join request -> member becomes active.
  Future<void> approveJoinRequest({
    required String communityId,
    required String requestId,
    required String adminId,
  }) async {
    final reqRef = _communities
        .doc(communityId)
        .collection('joinRequests')
        .doc(requestId);

    await _db.runTransaction((tx) async {
      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) return;
      final req = JoinRequest.fromDoc(reqSnap);
      if (req.status != 'pending') return;

      final memRef = _communities
          .doc(communityId)
          .collection('members')
          .doc(req.userId);

      tx.update(reqRef, <String, dynamic>{
        'status': 'approved',
        'processedBy': adminId,
        'processedAt': FieldValue.serverTimestamp(),
      });

      tx.set(memRef, <String, dynamic>{
        'status': 'active',
        'joinedAt': FieldValue.serverTimestamp(),
        'joinMethod': 'request',
        'approvedBy': adminId,
        'activeUser': true,
      }, SetOptions(merge: true));

      await _upsertUserMembershipIndex(
        tx: tx,
        userId: req.userId,
        communityId: communityId,
        data: <String, dynamic>{
          'communityId': communityId,
          'status': 'active',
          'joinMethod': 'request',
          'joinedAt': FieldValue.serverTimestamp(),
          'approvedBy': adminId,
          'activeUser': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    });
  }

  /// Admin: reject join request (does not create active membership).
  Future<void> rejectJoinRequest({
    required String communityId,
    required String requestId,
    required String adminId,
  }) async {
    final reqRef = _communities
        .doc(communityId)
        .collection('joinRequests')
        .doc(requestId);

    await _db.runTransaction((tx) async {
      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) return;
      final req = JoinRequest.fromDoc(reqSnap);
      if (req.status != 'pending') return;

      tx.update(reqRef, <String, dynamic>{
        'status': 'rejected',
        'processedBy': adminId,
        'processedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Member: leave community.
  Future<void> leaveCommunity({
    required String communityId,
    required String userId,
  }) async {
    await _communities.doc(communityId).collection('members').doc(userId).set(
      <String, dynamic>{'status': 'left', 'activeUser': false},
      SetOptions(merge: true),
    );

    await _userMembershipRef(
      userId: userId,
      communityId: communityId,
    ).set(<String, dynamic>{
      'communityId': communityId,
      'status': 'left',
      'activeUser': false,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Admin: remove user from community.
  Future<void> removeMember({
    required String communityId,
    required String targetUserId,
    required String adminId,
  }) async {
    await _communities
        .doc(communityId)
        .collection('members')
        .doc(targetUserId)
        .set(<String, dynamic>{
          'status': 'removed',
          'activeUser': false,
          'removedBy': adminId,
          'removedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    await _userMembershipRef(
      userId: targetUserId,
      communityId: communityId,
    ).set(<String, dynamic>{
      'communityId': communityId,
      'status': 'removed',
      'activeUser': false,
      'removedBy': adminId,
      'removedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Manager/Super Admin: update permissions for a member.
  Future<void> setMemberPermissions({
    required String communityId,
    required String targetUserId,
    required List<String> permissions,
  }) async {
    await _communities
        .doc(communityId)
        .collection('members')
        .doc(targetUserId)
        .set(<String, dynamic>{
          'permissions': permissions,
        }, SetOptions(merge: true));
  }

  /// Admin: generate an invite code.
  Future<String> createInviteCode({
    required String communityId,
    required String adminId,
    int length = 8,
    int? maxUses,
    DateTime? expiresAt,
  }) async {
    final code = _randomCode(length);
    final doc = _communities
        .doc(communityId)
        .collection('inviteCodes')
        .doc(code);
    await doc.set(<String, dynamic>{
      'code': code,
      'active': true,
      'uses': 0,
      if (maxUses != null) 'maxUses': maxUses,
      if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': adminId,
    });
    return code;
  }

  /// User: redeem invitation code (collectionGroup lookup, then transactional redeem).
  Future<String?> redeemInviteCode({
    required String userId,
    required String code,
  }) async {
    final query = await _db
        .collectionGroup('inviteCodes')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final inviteDoc = query.docs.first;
    final communityId = inviteDoc.reference.parent.parent?.id;
    if (communityId == null) return null;

    final inviteRef = _communities
        .doc(communityId)
        .collection('inviteCodes')
        .doc(code);
    final memRef = _communities
        .doc(communityId)
        .collection('members')
        .doc(userId);

    await _db.runTransaction((tx) async {
      final inviteSnap = await tx.get(inviteRef);
      if (!inviteSnap.exists) {
        throw StateError('Invite code not found');
      }
      final invite = InviteCode.fromDoc(inviteSnap);
      if (!invite.active) {
        throw StateError('Invite code inactive');
      }
      if (invite.expiresAt != null &&
          invite.expiresAt!.isBefore(DateTime.now())) {
        throw StateError('Invite code expired');
      }
      if (invite.maxUses != null && invite.uses >= invite.maxUses!) {
        throw StateError('Invite code exhausted');
      }

      final existingMember = await tx.get(memRef);
      if (existingMember.exists) {
        final data = existingMember.data() as Map<String, dynamic>;
        final status = (data['status'] ?? '').toString();
        if (status == 'active') {
          // already in
          return;
        }
      }

      tx.update(inviteRef, <String, dynamic>{'uses': FieldValue.increment(1)});

      tx.set(memRef, <String, dynamic>{
        'status': 'active',
        'joinedAt': FieldValue.serverTimestamp(),
        'joinMethod': 'invitation',
        'invitedBy': invite.createdBy,
        'activeUser': true,
        'permissions': <String>[],
        'score': 0.0,
      }, SetOptions(merge: true));

      await _upsertUserMembershipIndex(
        tx: tx,
        userId: userId,
        communityId: communityId,
        data: <String, dynamic>{
          'communityId': communityId,
          'status': 'active',
          'joinMethod': 'invitation',
          'joinedAt': FieldValue.serverTimestamp(),
          'invitedBy': invite.createdBy,
          'activeUser': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    });

    return communityId;
  }

  /// Create a program under a community.
  Future<String> createProgram({
    required String communityId,
    required CommunityProgramType type,
    required String programTitle,
    int? userLimit,
    required String createdBy,
  }) async {
    final doc = _communities.doc(communityId).collection('programs').doc();
    await doc.set(<String, dynamic>{
      'communityId': communityId,
      'type': type.name,
      'programTitle': programTitle,
      if (userLimit != null) 'userLimit': userLimit,
      'participantsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });
    return doc.id;
  }

  Future<void> updateProgram({
    required String communityId,
    required String programId,
    String? programTitle,
    CommunityProgramType? type,
    int? userLimit,
  }) async {
    final patch = <String, dynamic>{};
    if (programTitle != null) patch['programTitle'] = programTitle;
    if (type != null) patch['type'] = type.name;
    if (userLimit != null) patch['userLimit'] = userLimit;
    if (patch.isEmpty) return;

    patch['updatedAt'] = FieldValue.serverTimestamp();

    await _communities
        .doc(communityId)
        .collection('programs')
        .doc(programId)
        .update(patch);
  }

  /// User: join a program within a community.
  ///
  /// - Validates the user is an active community member.
  /// - Enforces `userLimit` if set (null or 0 => no limit).
  /// - Writes participant doc at:
  ///   `communities/{communityId}/programs/{programId}/participants/{userId}`
  /// - Maintains a denormalized `participantsCount` on the program doc.
  Future<void> joinProgram({
    required String communityId,
    required String programId,
    required String userId,
  }) async {
    final memberRef = _communities
        .doc(communityId)
        .collection('members')
        .doc(userId);
    final programRef = _communities
        .doc(communityId)
        .collection('programs')
        .doc(programId);
    final participantRef = programRef.collection('participants').doc(userId);

    await _db.runTransaction((tx) async {
      // 1) Ensure user is an active community member
      final memberSnap = await tx.get(memberRef);
      if (!memberSnap.exists) {
        throw StateError('User is not a community member');
      }
      final memberData = (memberSnap.data() ?? <String, dynamic>{});
      final memberStatus = (memberData['status'] ?? '').toString();
      if (memberStatus != 'active') {
        throw StateError('User is not an active community member');
      }

      // 2) Load program
      final programSnap = await tx.get(programRef);
      if (!programSnap.exists) {
        throw StateError('Program not found');
      }
      final programData = (programSnap.data() ?? <String, dynamic>{});
      final int? userLimit = (programData['userLimit'] is num)
          ? (programData['userLimit'] as num).toInt()
          : int.tryParse((programData['userLimit'] ?? '').toString());
      final int limit = (userLimit == null) ? 0 : userLimit;
      final int currentCount = (programData['participantsCount'] is num)
          ? (programData['participantsCount'] as num).toInt()
          : int.tryParse(
                  (programData['participantsCount'] ?? '0').toString(),
                ) ??
                0;

      // 3) Idempotency: if already joined, do nothing
      final participantSnap = await tx.get(participantRef);
      if (participantSnap.exists) {
        return;
      }

      // 4) Enforce limit
      if (limit > 0 && currentCount >= limit) {
        throw StateError('Program is full');
      }

      // 5) Create participant doc
      tx.set(participantRef, <String, dynamic>{
        'userId': userId,
        'joinedAt': FieldValue.serverTimestamp(),
      });

      // 6) Increment participantsCount
      tx.update(programRef, <String, dynamic>{
        'participantsCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// User: leave a program within a community.
  ///
  /// - Deletes participant doc.
  /// - Decrements `participantsCount` (never below 0).
  Future<void> leaveProgram({
    required String communityId,
    required String programId,
    required String userId,
  }) async {
    final programRef = _communities
        .doc(communityId)
        .collection('programs')
        .doc(programId);
    final participantRef = programRef.collection('participants').doc(userId);

    await _db.runTransaction((tx) async {
      final programSnap = await tx.get(programRef);
      if (!programSnap.exists) {
        throw StateError('Program not found');
      }
      final programData = (programSnap.data() ?? <String, dynamic>{});
      final int currentCount = (programData['participantsCount'] is num)
          ? (programData['participantsCount'] as num).toInt()
          : int.tryParse(
                  (programData['participantsCount'] ?? '0').toString(),
                ) ??
                0;

      final participantSnap = await tx.get(participantRef);
      if (!participantSnap.exists) {
        // Idempotent: already not joined
        return;
      }

      tx.delete(participantRef);

      final nextCount = (currentCount - 1) < 0 ? 0 : (currentCount - 1);
      tx.update(programRef, <String, dynamic>{
        'participantsCount': nextCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Stream participant userIds for a program (admin view).
  Stream<List<String>> streamProgramParticipants({
    required String communityId,
    required String programId,
  }) {
    return _communities
        .doc(communityId)
        .collection('programs')
        .doc(programId)
        .collection('participants')
        .orderBy('joinedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => (d.data()['userId'] ?? d.id).toString())
              .toList(),
        );
  }

  /// Stream participant count for a program (cheap UI).
  Stream<int> streamProgramParticipantCount({
    required String communityId,
    required String programId,
  }) {
    return _communities
        .doc(communityId)
        .collection('programs')
        .doc(programId)
        .snapshots()
        .map((doc) {
          final data = doc.data() ?? <String, dynamic>{};
          final v = data['participantsCount'];
          if (v is num) return v.toInt();
          return int.tryParse((v ?? '0').toString()) ?? 0;
        });
  }

  DocumentReference<Map<String, dynamic>> _userMembershipRef({
    required String userId,
    required String communityId,
  }) {
    return _users.doc(userId).collection('memberships').doc(communityId);
  }

  Future<void> _upsertUserMembershipIndex({
    required Transaction tx,
    required String userId,
    required String communityId,
    required Map<String, dynamic> data,
  }) async {
    final ref = _userMembershipRef(userId: userId, communityId: communityId);
    tx.set(ref, data, SetOptions(merge: true));
  }

  String _randomCode(int length) {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(
      length,
      (_) => alphabet[r.nextInt(alphabet.length)],
    ).join();
  }
}

class CommunityMembershipRef {
  final String communityId;
  final CommunityMember member;
  const CommunityMembershipRef({
    required this.communityId,
    required this.member,
  });
}
