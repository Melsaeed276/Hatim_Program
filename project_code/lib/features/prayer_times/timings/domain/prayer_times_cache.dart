import 'prayer_day.dart';

class CachedPrayerMonth {
  const CachedPrayerMonth({
    required this.days,
    required this.fetchedAt,
    required this.provider,
  });

  final List<PrayerDay> days;
  final DateTime fetchedAt;
  final String provider;
}

abstract class PrayerTimesCache {
  Future<CachedPrayerMonth?> read(String cacheKey);

  Future<void> write(String cacheKey, CachedPrayerMonth month);
}
