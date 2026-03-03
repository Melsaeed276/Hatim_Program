import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/prayer_times/location/domain/location_models.dart';

void main() {
  final Map<String, Object?> baseMap = <String, Object?>{
    'latitude': 41.0082,
    'longitude': 28.9784,
    'timezone': 'Europe/Istanbul',
    'city': 'Istanbul',
    'country': 'Turkey',
    'source': 'gps',
  };

  test('fromMap parses Firestore Timestamp for updatedAt', () {
    final DateTime expected = DateTime.utc(2024, 6, 15, 12, 0, 0);
    final Timestamp timestamp = Timestamp.fromDate(expected);

    final UserLocationProfile profile = UserLocationProfile.fromMap(<String, Object?>{
      ...baseMap,
      'updatedAt': timestamp,
    });

    expect(profile.updatedAt, expected);
  });

  test('fromMap parses DateTime for updatedAt', () {
    final DateTime expected = DateTime.utc(2024, 6, 15, 12, 0, 0);

    final UserLocationProfile profile = UserLocationProfile.fromMap(<String, Object?>{
      ...baseMap,
      'updatedAt': expected,
    });

    expect(profile.updatedAt, expected);
  });

  test('fromMap parses ISO 8601 string for updatedAt', () {
    final DateTime expected = DateTime.utc(2024, 6, 15, 12, 0, 0);

    final UserLocationProfile profile = UserLocationProfile.fromMap(<String, Object?>{
      ...baseMap,
      'updatedAt': '2024-06-15T12:00:00.000Z',
    });

    expect(profile.updatedAt, expected);
  });

  test('fromMap parses int (epoch ms) for updatedAt', () {
    final DateTime expected = DateTime.utc(2024, 6, 15, 12, 0, 0);
    final int epochMs = expected.millisecondsSinceEpoch;

    final UserLocationProfile profile = UserLocationProfile.fromMap(<String, Object?>{
      ...baseMap,
      'updatedAt': epochMs,
    });

    expect(profile.updatedAt, expected);
  });

  test('fromMap falls back to now when updatedAt is null', () {
    final DateTime before = DateTime.now().toUtc();

    final UserLocationProfile profile = UserLocationProfile.fromMap(<String, Object?>{
      ...baseMap,
      'updatedAt': null,
    });

    final DateTime after = DateTime.now().toUtc();
    expect(
      profile.updatedAt.isAfter(before.subtract(const Duration(seconds: 1))),
      isTrue,
    );
    expect(
      profile.updatedAt.isBefore(after.add(const Duration(seconds: 1))),
      isTrue,
    );
  });
}
