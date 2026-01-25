

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hatim_program/features/community/models/models.dart';
import 'package:hatim_program/features/community/services/community_service.dart';

/// Firebase Emulator Suite (Firestore) tests for CommunityService.
///
/// Prerequisites:
/// - Start emulator before running tests:
///   firebase emulators:start --only firestore
/// - Default emulator host/port assumed: localhost:8080
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseFirestore db;
  late CommunityService service;

  const emulatorHost = '127.0.0.1';
  const emulatorPort = 8080;

  setUpAll(() async {
    // In Flutter tests there is often no default Firebase app configured.
    // Create a default app with dummy options. Firestore will be redirected to the emulator.
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'fake-api-key',
          appId: '1:1234567890:android:1234567890abcdef',
          messagingSenderId: '1234567890',
          projectId: 'demo-test',
        ),
      );
    }

    db = FirebaseFirestore.instance;
    db.useFirestoreEmulator(emulatorHost, emulatorPort);
    db.settings = const Settings(persistenceEnabled: false);

    service = CommunityService(db: db);
  });

  setUp(() async {
    await _clearFirestore(db);
  });

  group('Communities', () {
    test('createCommunity writes required fields', () async {
      final id = await service.createCommunity(
        name: 'Test Community',
        description: 'Desc',
        createdBy: 'admin1',
      );

      final snap = await db.collection('communities').doc(id).get();
      expect(snap.exists, true);

      final data = snap.data()!;
      expect(data['name'], 'Test Community');
      expect(data['description'], 'Desc');
      expect(data['status'], 'active');
      expect(data['createdBy'], 'admin1');
      expect(data.containsKey('createdAt'), true);
    });

    test('createCommunity writes optional country allow-list fields', () async {
      final id = await service.createCommunity(
        name: 'C',
        description: 'D',
        createdBy: 'admin1',
        createdCountry: 'TR',
        allowedCountries: const ['TR', 'DE'],
      );

      final snap = await db.collection('communities').doc(id).get();
      final data = snap.data()!;
      expect(data['createdCountry'], 'TR');
      expect((data['allowedCountries'] as List).map((e) => e.toString()).toList(),
          containsAll(<String>['TR', 'DE']));
    });

    test('getCommunity returns null if missing', () async {
      final c = await service.getCommunity('does-not-exist');
      expect(c, isNull);
    });

    test('streamCommunities filters archived by default', () async {
      await db.collection('communities').doc('c_active').set({
        'name': 'A',
        'description': 'A',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'admin',
      });
      await db.collection('communities').doc('c_archived').set({
        'name': 'B',
        'description': 'B',
        'status': 'archived',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'admin',
      });

      final items = await _firstValue(service.streamCommunities());
      expect(items.map((e) => e.id), equals(['c_active']));
    });

    test('streamCommunities(includeArchived=true) returns all', () async {
      await db.collection('communities').doc('c_active').set({
        'name': 'A',
        'description': 'A',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'admin',
      });
      await db.collection('communities').doc('c_archived').set({
        'name': 'B',
        'description': 'B',
        'status': 'archived',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'admin',
      });

      final items = await _firstValue(service.streamCommunities(includeArchived: true));
      expect(items.map((e) => e.id).toSet(), equals({'c_active', 'c_archived'}));
    });

    test('updateCommunity updates provided fields and sets updatedAt', () async {
      final id = await service.createCommunity(
        name: 'Before',
        description: 'Desc',
        createdBy: 'admin',
      );

      await service.updateCommunity(
        communityId: id,
        name: 'After',
      );

      final snap = await db.collection('communities').doc(id).get();
      final data = snap.data()!;
      expect(data['name'], 'After');
      expect(data['description'], 'Desc');
      expect(data.containsKey('updatedAt'), true);
    });

    test('archiveCommunity sets status archived', () async {
      final id = await service.createCommunity(
        name: 'C',
        description: 'D',
        createdBy: 'admin',
      );

      await service.archiveCommunity(id);

      final snap = await db.collection('communities').doc(id).get();
      expect(snap.data()!['status'], 'archived');
    });
  });

  group('Membership streams', () {
    test('streamMyMembership returns null when doc missing', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      final v = await _firstValue(
        service.streamMyMembership(communityId: cid, userId: 'u1'),
      );
      expect(v, isNull);
    });

    test('streamMyMembership returns member when exists', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');

      final v = await _firstValue(
        service.streamMyMembership(communityId: cid, userId: 'u1'),
      );
      expect(v, isNotNull);
      expect(v!.status, CommunityMemberStatus.active);
    });

    test('streamMembers returns all members', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');
      await _seedMember(db, communityId: cid, userId: 'u2', status: 'pending');

      final items = await _firstValue(service.streamMembers(cid));
      expect(items.map((m) => m.userId).toSet(), equals({'u1', 'u2'}));
    });

    test('streamMyMembershipRefsFromUserIndex returns membership refs', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await db.collection('users').doc('u1').collection('memberships').doc(cid).set({
        'communityId': cid,
        'status': 'active',
        'joinMethod': 'request',
        'activeUser': true,
      });

      final refs = await _firstValue(service.streamMyMembershipRefsFromUserIndex('u1'));
      expect(refs.length, 1);
      expect(refs.first.communityId, cid);
      expect(refs.first.member.status, CommunityMemberStatus.active);
    });
  });

  group('Join Requests (transactions)', () {
    test('createJoinRequest creates joinRequest + member + user index', () async {
      final cid = await _seedCommunity(db, id: 'c1');

      await service.createJoinRequest(communityId: cid, userId: 'u1');

      final reqs = await db.collection('communities').doc(cid).collection('joinRequests').get();
      expect(reqs.docs.length, 1);
      expect(reqs.docs.first.data()['status'], 'pending');
      expect(reqs.docs.first.data()['userId'], 'u1');

      final mem = await db.collection('communities').doc(cid).collection('members').doc('u1').get();
      expect(mem.exists, true);
      expect(mem.data()!['status'], 'pending');
      expect(mem.data()!['joinMethod'], 'request');

      final idx = await db.collection('users').doc('u1').collection('memberships').doc(cid).get();
      expect(idx.exists, true);
      expect(idx.data()!['status'], 'pending');
      expect(idx.data()!['joinMethod'], 'request');
    });

    test('createJoinRequest is idempotent for pending member (no duplicate requests)', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'pending');

      await service.createJoinRequest(communityId: cid, userId: 'u1');

      final reqs = await db.collection('communities').doc(cid).collection('joinRequests').get();
      expect(reqs.docs.length, 0);
    });

    test('approveJoinRequest sets member active and updates user index', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await service.createJoinRequest(communityId: cid, userId: 'u1');

      final reqs = await db.collection('communities').doc(cid).collection('joinRequests').get();
      final requestId = reqs.docs.first.id;

      await service.approveJoinRequest(
        communityId: cid,
        requestId: requestId,
        adminId: 'admin1',
      );

      final req = await db
          .collection('communities')
          .doc(cid)
          .collection('joinRequests')
          .doc(requestId)
          .get();
      expect(req.data()!['status'], 'approved');
      expect(req.data()!['processedBy'], 'admin1');

      final mem = await db.collection('communities').doc(cid).collection('members').doc('u1').get();
      expect(mem.data()!['status'], 'active');
      expect(mem.data()!['approvedBy'], 'admin1');
      expect(mem.data()!.containsKey('joinedAt'), true);

      final idx = await db.collection('users').doc('u1').collection('memberships').doc(cid).get();
      expect(idx.data()!['status'], 'active');
      expect(idx.data()!['approvedBy'], 'admin1');
    });

    test('rejectJoinRequest sets request rejected', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await service.createJoinRequest(communityId: cid, userId: 'u1');

      final reqs = await db.collection('communities').doc(cid).collection('joinRequests').get();
      final requestId = reqs.docs.first.id;

      await service.rejectJoinRequest(
        communityId: cid,
        requestId: requestId,
        adminId: 'admin1',
      );

      final req = await db
          .collection('communities')
          .doc(cid)
          .collection('joinRequests')
          .doc(requestId)
          .get();
      expect(req.data()!['status'], 'rejected');
      expect(req.data()!['processedBy'], 'admin1');
    });
  });

  group('Leave / Remove', () {
    test('leaveCommunity sets member status left and updates user index', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');

      await service.leaveCommunity(communityId: cid, userId: 'u1');

      final mem = await db.collection('communities').doc(cid).collection('members').doc('u1').get();
      expect(mem.data()!['status'], 'left');
      expect(mem.data()!['activeUser'], false);

      final idx = await db.collection('users').doc('u1').collection('memberships').doc(cid).get();
      expect(idx.data()!['status'], 'left');
      expect(idx.data()!['activeUser'], false);
    });

    test('removeMember sets removed fields and updates user index', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');

      await service.removeMember(
        communityId: cid,
        targetUserId: 'u1',
        adminId: 'admin1',
      );

      final mem = await db.collection('communities').doc(cid).collection('members').doc('u1').get();
      expect(mem.data()!['status'], 'removed');
      expect(mem.data()!['removedBy'], 'admin1');

      final idx = await db.collection('users').doc('u1').collection('memberships').doc(cid).get();
      expect(idx.data()!['status'], 'removed');
      expect(idx.data()!['removedBy'], 'admin1');
    });
  });

  group('Invite Codes', () {
    test('redeemInviteCode returns null if not found', () async {
      final res = await service.redeemInviteCode(userId: 'u1', code: 'NOTFOUND');
      expect(res, isNull);
    });

    test('redeemInviteCode activates membership and increments uses', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      final code = await service.createInviteCode(communityId: cid, adminId: 'admin1', length: 8);

      final redeemedCid = await service.redeemInviteCode(userId: 'u1', code: code);
      expect(redeemedCid, cid);

      final invite = await db.collection('communities').doc(cid).collection('inviteCodes').doc(code).get();
      expect(invite.data()!['uses'], 1);

      final mem = await db.collection('communities').doc(cid).collection('members').doc('u1').get();
      expect(mem.data()!['status'], 'active');
      expect(mem.data()!['joinMethod'], 'invitation');
      expect(mem.data()!['invitedBy'], 'admin1');

      final idx = await db.collection('users').doc('u1').collection('memberships').doc(cid).get();
      expect(idx.data()!['status'], 'active');
      expect(idx.data()!['joinMethod'], 'invitation');
      expect(idx.data()!['invitedBy'], 'admin1');
    });

    test('redeemInviteCode is idempotent for already-active member (uses not incremented again)', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      final code = await service.createInviteCode(communityId: cid, adminId: 'admin1', length: 8);

      await service.redeemInviteCode(userId: 'u1', code: code);
      await service.redeemInviteCode(userId: 'u1', code: code);

      final invite = await db.collection('communities').doc(cid).collection('inviteCodes').doc(code).get();
      expect(invite.data()!['uses'], 1);
    });
  });

  group('Programs', () {
    test('createProgram writes schema fields including participantsCount=0', () async {
      final cid = await _seedCommunity(db, id: 'c1');

      final pid = await service.createProgram(
        communityId: cid,
        type: CommunityProgramType.quran,
        programTitle: 'Ramadan Hatim',
        userLimit: 30,
        createdBy: 'admin1',
      );

      final p = await db.collection('communities').doc(cid).collection('programs').doc(pid).get();
      final data = p.data()!;
      expect(data['type'], 'quran');
      expect(data['programTitle'], 'Ramadan Hatim');
      expect(data['userLimit'], 30);
      expect(data['participantsCount'], 0);
    });

    test('streamPrograms returns created program', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      final pid = await service.createProgram(
        communityId: cid,
        type: CommunityProgramType.zikir,
        programTitle: 'Morning Zikir',
        createdBy: 'admin1',
      );

      final items = await _firstValue(service.streamPrograms(cid));
      expect(items.any((p) => p.id == pid), true);
    });

    test('getMyProgramsAcrossCommunities returns programs for active communities', () async {
      final c1 = await _seedCommunity(db, id: 'c1');
      final c2 = await _seedCommunity(db, id: 'c2');

      // user is active in c1 and not active in c2
      await _seedUserIndex(db, userId: 'u1', communityId: c1, status: 'active');
      await _seedUserIndex(db, userId: 'u1', communityId: c2, status: 'pending');

      await service.createProgram(
        communityId: c1,
        type: CommunityProgramType.quran,
        programTitle: 'P1',
        createdBy: 'admin',
      );
      await service.createProgram(
        communityId: c2,
        type: CommunityProgramType.quran,
        programTitle: 'P2',
        createdBy: 'admin',
      );

      final list = await service.getMyProgramsAcrossCommunities(userId: 'u1');
      expect(list.any((p) => p.communityId == c1), true);
      expect(list.any((p) => p.communityId == c2), false);
    });
  });

  group('Program participation (transactions + counters)', () {
    test('joinProgram fails if user is not a community member', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 10);

      expect(
        () => service.joinProgram(communityId: cid, programId: pid, userId: 'u1'),
        throwsA(isA<StateError>()),
      );
    });

    test('joinProgram fails if user is not active member', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 10);
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'pending');

      expect(
        () => service.joinProgram(communityId: cid, programId: pid, userId: 'u1'),
        throwsA(isA<StateError>()),
      );
    });

    test('joinProgram creates participant doc and increments count (idempotent)', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 10);

      await service.joinProgram(communityId: cid, programId: pid, userId: 'u1');
      await service.joinProgram(communityId: cid, programId: pid, userId: 'u1');

      final participant = await db
          .collection('communities')
          .doc(cid)
          .collection('programs')
          .doc(pid)
          .collection('participants')
          .doc('u1')
          .get();
      expect(participant.exists, true);

      final program = await db.collection('communities').doc(cid).collection('programs').doc(pid).get();
      expect(program.data()!['participantsCount'], 1);
    });

    test('joinProgram enforces userLimit', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');
      await _seedMember(db, communityId: cid, userId: 'u2', status: 'active');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 1);

      await service.joinProgram(communityId: cid, programId: pid, userId: 'u1');

      expect(
        () => service.joinProgram(communityId: cid, programId: pid, userId: 'u2'),
        throwsA(isA<StateError>()),
      );

      final program = await db.collection('communities').doc(cid).collection('programs').doc(pid).get();
      expect(program.data()!['participantsCount'], 1);
    });

    test('leaveProgram is idempotent and decrements count (never negative)', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 10);

      // Leave without join: idempotent
      await service.leaveProgram(communityId: cid, programId: pid, userId: 'u1');

      var program = await db.collection('communities').doc(cid).collection('programs').doc(pid).get();
      expect(program.data()!['participantsCount'], 0);

      // Join then leave
      await service.joinProgram(communityId: cid, programId: pid, userId: 'u1');
      await service.leaveProgram(communityId: cid, programId: pid, userId: 'u1');

      final participant = await db
          .collection('communities')
          .doc(cid)
          .collection('programs')
          .doc(pid)
          .collection('participants')
          .doc('u1')
          .get();
      expect(participant.exists, false);

      program = await db.collection('communities').doc(cid).collection('programs').doc(pid).get();
      expect(program.data()!['participantsCount'], 0);

      // Leave again: still 0
      await service.leaveProgram(communityId: cid, programId: pid, userId: 'u1');
      program = await db.collection('communities').doc(cid).collection('programs').doc(pid).get();
      expect(program.data()!['participantsCount'], 0);
    });

    test('streamProgramParticipantCount reflects join/leave', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 10);

      final sub = service.streamProgramParticipantCount(communityId: cid, programId: pid);

      final initial = await _firstValue(sub);
      expect(initial, 0);

      await service.joinProgram(communityId: cid, programId: pid, userId: 'u1');
      final afterJoin = await _firstValue(sub.where((v) => v == 1));
      expect(afterJoin, 1);

      await service.leaveProgram(communityId: cid, programId: pid, userId: 'u1');
      final afterLeave = await _firstValue(sub.where((v) => v == 0));
      expect(afterLeave, 0);
    });

    test('streamProgramParticipants contains joined userIds', () async {
      final cid = await _seedCommunity(db, id: 'c1');
      await _seedMember(db, communityId: cid, userId: 'u1', status: 'active');
      await _seedMember(db, communityId: cid, userId: 'u2', status: 'active');
      final pid = await _seedProgram(db, communityId: cid, programId: 'p1', userLimit: 10);

      final sub = service.streamProgramParticipants(communityId: cid, programId: pid);
      final initial = await _firstValue(sub);
      expect(initial, isEmpty);

      await service.joinProgram(communityId: cid, programId: pid, userId: 'u1');
      await service.joinProgram(communityId: cid, programId: pid, userId: 'u2');

      final after = await _firstValue(sub.where((list) => list.length == 2));
      expect(after.toSet(), equals({'u1', 'u2'}));
    });
  });
}

// -------------------------------
// Helpers
// -------------------------------

Future<T> _firstValue<T>(Stream<T> stream, {Duration timeout = const Duration(seconds: 5)}) {
  return stream.first.timeout(timeout);
}

Future<void> _clearFirestore(FirebaseFirestore db) async {
  // Delete top-level collections we use.
  await _deleteCollection(db.collection('communities'));
  await _deleteCollection(db.collection('users'));
}

Future<void> _deleteCollection(CollectionReference<Map<String, dynamic>> col) async {
  final snap = await col.get();
  for (final doc in snap.docs) {
    // Manually delete known subcollections used by the app
    await _deleteKnownSubcollections(doc.reference);
    await doc.reference.delete();
  }
}

Future<void> _deleteKnownSubcollections(
  DocumentReference<Map<String, dynamic>> docRef,
) async {
  // Firestore Flutter SDK does NOT support listCollections().
  // We must explicitly delete known subcollections.

  const knownSubcollections = <String>[
    'members',
    'joinRequests',
    'inviteCodes',
    'programs',
    'participants',
    'memberships',
  ];

  for (final name in knownSubcollections) {
    final col = docRef.collection(name);
    final snap = await col.get();
    for (final d in snap.docs) {
      // programs have nested participants
      if (name == 'programs') {
        final participants = d.reference.collection('participants');
        final pSnap = await participants.get();
        for (final p in pSnap.docs) {
          await p.reference.delete();
        }
      }
      await d.reference.delete();
    }
  }
}

Future<String> _seedCommunity(FirebaseFirestore db, {required String id}) async {
  await db.collection('communities').doc(id).set({
    'name': 'Seed $id',
    'description': 'Seed',
    'status': 'active',
    'createdAt': FieldValue.serverTimestamp(),
    'createdBy': 'admin',
  });
  return id;
}

Future<void> _seedUserIndex(
  FirebaseFirestore db, {
  required String userId,
  required String communityId,
  required String status,
}) async {
  await db.collection('users').doc(userId).collection('memberships').doc(communityId).set({
    'communityId': communityId,
    'status': status,
    'joinMethod': 'request',
    'activeUser': status == 'active',
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

Future<void> _seedMember(
  FirebaseFirestore db, {
  required String communityId,
  required String userId,
  required String status,
}) async {
  await db.collection('communities').doc(communityId).collection('members').doc(userId).set({
    'status': status,
    'joinMethod': 'request',
    'activeUser': status == 'active',
    'permissions': <String>[],
    'score': 0.0,
  }, SetOptions(merge: true));

  // Keep user index reasonably consistent for tests that use it.
  await db.collection('users').doc(userId).collection('memberships').doc(communityId).set({
    'communityId': communityId,
    'status': status,
    'joinMethod': 'request',
    'activeUser': status == 'active',
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

Future<String> _seedProgram(
  FirebaseFirestore db, {
  required String communityId,
  required String programId,
  int? userLimit,
}) async {
  await db.collection('communities').doc(communityId).collection('programs').doc(programId).set({
    'communityId': communityId,
    'type': 'quran',
    'programTitle': 'Seed Program',
    if (userLimit != null) 'userLimit': userLimit,
    'participantsCount': 0,
    'createdAt': FieldValue.serverTimestamp(),
    'createdBy': 'admin',
  });
  return programId;
}
