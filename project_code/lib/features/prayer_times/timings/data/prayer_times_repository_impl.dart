import '../domain/prayer_month_result.dart';
import '../domain/prayer_times_cache.dart';
import '../domain/prayer_times_data_source.dart';
import '../domain/prayer_times_repository.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  PrayerTimesRepositoryImpl({
    required PrayerTimesDataSource primaryDataSource,
    required PrayerTimesCache cache,
    PrayerTimesFallbackDataSource? fallbackDataSource,
    bool fallbackEnabled = false,
  }) : _primaryDataSource = primaryDataSource,
       _cache = cache,
       _fallbackDataSource = fallbackDataSource,
       _fallbackEnabled = fallbackEnabled;

  final PrayerTimesDataSource _primaryDataSource;
  final PrayerTimesCache _cache;
  final PrayerTimesFallbackDataSource? _fallbackDataSource;
  final bool _fallbackEnabled;

  @override
  Future<PrayerMonthResult> getMonthlyCalendar({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
    bool forceRefresh = false,
  }) async {
    final String cacheKey = _cacheKey(
      year: year,
      month: month,
      city: city,
      country: country,
      method: method,
    );

    final CachedPrayerMonth? cached = await _cache.read(cacheKey);
    final bool hasFreshCache =
        cached != null && _sameUtcDay(cached.fetchedAt, DateTime.now().toUtc());

    if (!forceRefresh && hasFreshCache) {
      return PrayerMonthResult(
        days: cached.days,
        provider: cached.provider,
        fromCache: true,
        isStale: false,
      );
    }

    try {
      final days = await _primaryDataSource.fetchMonthlyCalendar(
        year: year,
        month: month,
        city: city,
        country: country,
        method: method,
      );
      final CachedPrayerMonth monthCache = CachedPrayerMonth(
        days: days,
        fetchedAt: DateTime.now().toUtc(),
        provider: _primaryDataSource.providerId,
      );
      await _cache.write(cacheKey, monthCache);
      return PrayerMonthResult(
        days: days,
        provider: _primaryDataSource.providerId,
        fromCache: false,
        isStale: false,
      );
    } catch (_) {
      if (_fallbackEnabled && _fallbackDataSource != null) {
        final days = await _fallbackDataSource.fetchMonthlyCalendar(
          year: year,
          month: month,
          city: city,
          country: country,
          method: method,
        );
        final CachedPrayerMonth monthCache = CachedPrayerMonth(
          days: days,
          fetchedAt: DateTime.now().toUtc(),
          provider: _fallbackDataSource.providerId,
        );
        await _cache.write(cacheKey, monthCache);
        return PrayerMonthResult(
          days: days,
          provider: _fallbackDataSource.providerId,
          fromCache: false,
          isStale: false,
        );
      }

      if (cached != null) {
        return PrayerMonthResult(
          days: cached.days,
          provider: cached.provider,
          fromCache: true,
          isStale: true,
        );
      }
      rethrow;
    }
  }

  bool _sameUtcDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  String _cacheKey({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
  }) {
    final String normalizedCity = city.trim().toLowerCase();
    final String normalizedCountry = country.trim().toLowerCase();
    return '$year-$month-$normalizedCity-$normalizedCountry-$method';
  }
}
