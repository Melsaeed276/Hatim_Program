class Coordinates {
  const Coordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class PlaceDetails {
  const PlaceDetails({required this.city, required this.country});

  final String city;
  final String country;
}

enum LocationSource { gps, manual }

class UserLocationProfile {
  const UserLocationProfile({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.city,
    required this.country,
    required this.source,
    required this.updatedAt,
  });

  final double latitude;
  final double longitude;
  final String timezone;
  final String city;
  final String country;
  final LocationSource source;
  final DateTime updatedAt;

  Map<String, Object> toFirestoreMap() {
    return <String, Object>{
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'city': city,
      'country': country,
      'source': source.name,
      'updatedAt': updatedAt.toUtc(),
    };
  }

  static UserLocationProfile fromMap(Map<String, Object?> map) {
    final Object? updatedAtRaw = map['updatedAt'];
    final DateTime updatedAt = _toDateTime(updatedAtRaw);

    return UserLocationProfile(
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      timezone: '${map['timezone'] ?? 'UTC'}',
      city: '${map['city'] ?? ''}',
      country: '${map['country'] ?? ''}',
      source: _parseSource('${map['source'] ?? LocationSource.manual.name}'),
      updatedAt: updatedAt,
    );
  }

  static LocationSource _parseSource(String raw) {
    return LocationSource.values.firstWhere(
      (LocationSource value) => value.name == raw,
      orElse: () => LocationSource.manual,
    );
  }

  /// Converts a raw [value] from a map (e.g. Firestore Timestamp, DateTime,
  /// or ISO-8601 string) to a [DateTime]. Uses duck-typing for Timestamp to
  /// avoid a hard dependency on cloud_firestore in the domain layer.
  static DateTime _toDateTime(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value != null) {
      try {
        // Handles Firestore Timestamp (and any other type exposing toDate()).
        return (value as dynamic).toDate() as DateTime;
      } catch (_) {
        // Fall through to string parsing below.
      }
    }
    return DateTime.tryParse('${value ?? ''}') ?? DateTime.now().toUtc();
  }
}
