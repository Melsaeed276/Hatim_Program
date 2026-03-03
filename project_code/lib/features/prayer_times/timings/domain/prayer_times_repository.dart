import 'prayer_month_result.dart';

abstract class PrayerTimesRepository {
  Future<PrayerMonthResult> getMonthlyCalendar({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
    bool forceRefresh = false,
  });
}
