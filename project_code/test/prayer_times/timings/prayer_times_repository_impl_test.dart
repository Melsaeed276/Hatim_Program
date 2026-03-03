import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/prayer_times/timings/data/prayer_times_repository_impl.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_day.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_times_cache.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_times_data_source.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_times_failure.dart';

class FakePrimaryDataSource implements PrayerTimesDataSource {
  FakePrimaryDataSource({required this.result, this.throwOnFetch = false});

  final List<PrayerDay> result;
  final bool throwOnFetch;
  int callCount = 0;

  @override
  Future<List<PrayerDay>> fetchMonthlyCalendar({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
  }) async {
    callCount += 1;
    if (throwOnFetch) {
      throw const PrayerTimesFailure(
        PrayerTimesFailureType.network,
        'network error',
      );
    }
    return result;
  }

  @override
  String get providerId => 'aladhan';
}

class InMemoryPrayerTimesCache implements PrayerTimesCache {
  CachedPrayerMonth? cached;

  @override
  Future<CachedPrayerMonth?> read(String cacheKey) async => cached;

  @override
  Future<void> write(String cacheKey, CachedPrayerMonth month) async {
    cached = month;
  }
}

PrayerDay buildPrayerDay() {
  return PrayerDay(
    date: DateTime.utc(2026, 3, 3),
    timezone: 'Europe/Istanbul',
    method: 'Diyanet',
    fajr: '06:04',
    sunrise: '07:28',
    dhuhr: '13:20',
    asr: '16:30',
    maghrib: '19:10',
    isha: '20:25',
  );
}

void main() {
  test('uses fresh cache and skips remote call', () async {
    final InMemoryPrayerTimesCache cache = InMemoryPrayerTimesCache()
      ..cached = CachedPrayerMonth(
        days: <PrayerDay>[buildPrayerDay()],
        fetchedAt: DateTime.now().toUtc(),
        provider: 'aladhan',
      );
    final FakePrimaryDataSource source = FakePrimaryDataSource(
      result: <PrayerDay>[buildPrayerDay()],
    );

    final PrayerTimesRepositoryImpl repository = PrayerTimesRepositoryImpl(
      primaryDataSource: source,
      cache: cache,
    );

    final result = await repository.getMonthlyCalendar(
      year: 2026,
      month: 3,
      city: 'Istanbul',
      country: 'Turkey',
      method: 13,
    );

    expect(result.fromCache, isTrue);
    expect(result.isStale, isFalse);
    expect(source.callCount, 0);
  });

  test('returns stale cache when remote fails', () async {
    final InMemoryPrayerTimesCache cache = InMemoryPrayerTimesCache()
      ..cached = CachedPrayerMonth(
        days: <PrayerDay>[buildPrayerDay()],
        fetchedAt: DateTime.utc(2026, 1, 1),
        provider: 'aladhan',
      );
    final FakePrimaryDataSource source = FakePrimaryDataSource(
      result: <PrayerDay>[buildPrayerDay()],
      throwOnFetch: true,
    );

    final PrayerTimesRepositoryImpl repository = PrayerTimesRepositoryImpl(
      primaryDataSource: source,
      cache: cache,
    );

    final result = await repository.getMonthlyCalendar(
      year: 2026,
      month: 3,
      city: 'Istanbul',
      country: 'Turkey',
      method: 13,
      forceRefresh: true,
    );

    expect(result.fromCache, isTrue);
    expect(result.isStale, isTrue);
  });

  test('fetches remote data and writes cache', () async {
    final InMemoryPrayerTimesCache cache = InMemoryPrayerTimesCache();
    final FakePrimaryDataSource source = FakePrimaryDataSource(
      result: <PrayerDay>[buildPrayerDay()],
    );

    final PrayerTimesRepositoryImpl repository = PrayerTimesRepositoryImpl(
      primaryDataSource: source,
      cache: cache,
    );

    final result = await repository.getMonthlyCalendar(
      year: 2026,
      month: 3,
      city: 'Istanbul',
      country: 'Turkey',
      method: 13,
      forceRefresh: true,
    );

    expect(result.fromCache, isFalse);
    expect(result.provider, 'aladhan');
    expect(cache.cached, isNotNull);
    expect(source.callCount, 1);
  });
}
