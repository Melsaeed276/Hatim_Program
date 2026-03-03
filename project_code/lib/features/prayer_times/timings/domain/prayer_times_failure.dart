enum PrayerTimesFailureType {
  network,
  parsing,
  invalidLocation,
  providerUnavailable,
}

class PrayerTimesFailure implements Exception {
  const PrayerTimesFailure(this.type, this.message);

  final PrayerTimesFailureType type;
  final String message;

  @override
  String toString() => 'PrayerTimesFailure(type: $type, message: $message)';
}
