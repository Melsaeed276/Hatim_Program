import 'prayer_day.dart';

abstract class PrayerTimesDataSource {
  Future<List<PrayerDay>> fetchMonthlyCalendar({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
  });

  String get providerId;
}

abstract class PrayerTimesFallbackDataSource implements PrayerTimesDataSource {}
