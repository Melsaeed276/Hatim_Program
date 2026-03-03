import '../domain/prayer_day.dart';
import '../domain/prayer_times_data_source.dart';
import '../domain/prayer_times_failure.dart';

class EzanVaktiFallbackDataSource implements PrayerTimesFallbackDataSource {
  @override
  String get providerId => 'ezanvakti';

  @override
  Future<List<PrayerDay>> fetchMonthlyCalendar({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
  }) {
    throw const PrayerTimesFailure(
      PrayerTimesFailureType.providerUnavailable,
      'Fallback adapter is not enabled in MVP yet.',
    );
  }
}
