import 'prayer_day.dart';

class PrayerMonthResult {
  const PrayerMonthResult({
    required this.days,
    required this.provider,
    required this.fromCache,
    required this.isStale,
  });

  final List<PrayerDay> days;
  final String provider;
  final bool fromCache;
  final bool isStale;
}
