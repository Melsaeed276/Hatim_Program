import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/location_models.dart';
import '../domain/location_services.dart';

class FirestoreLocationProfileRepository implements LocationProfileRepository {
  FirestoreLocationProfileRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserLocationProfile?> loadLocation() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final Map<String, dynamic>? data = document.data();
    if (data == null) {
      return null;
    }

    final Map<String, dynamic>? locationMap =
        data['location'] as Map<String, dynamic>?;
    if (locationMap == null) {
      return null;
    }

    return UserLocationProfile(
      latitude: (locationMap['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (locationMap['longitude'] as num?)?.toDouble() ?? 0,
      timezone: '${locationMap['timezone'] ?? 'UTC'}',
      city: '${locationMap['city'] ?? ''}',
      country: '${locationMap['country'] ?? ''}',
      source: _parseSource(
        '${locationMap['source'] ?? LocationSource.manual.name}',
      ),
      updatedAt: _toDateTime(locationMap['updatedAt']),
    );
  }

  @override
  Future<void> saveLocation(UserLocationProfile location) async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Cannot save location without an authenticated user.');
    }

    await _firestore.collection('users').doc(user.uid).set(<String, Object>{
      'location': <String, Object>{
        ...location.toFirestoreMap(),
        'updatedAt': Timestamp.fromDate(location.updatedAt.toUtc()),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  LocationSource _parseSource(String raw) {
    return LocationSource.values.firstWhere(
      (LocationSource value) => value.name == raw,
      orElse: () => LocationSource.manual,
    );
  }

  DateTime _toDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now().toUtc();
  }
}
