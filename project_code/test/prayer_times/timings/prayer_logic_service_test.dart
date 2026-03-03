import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_day.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_logic_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;

PrayerDay buildDay({
  required DateTime date,
  required String timezone,
  required String fajr,
  required String dhuhr,
  required String asr,
  required String maghrib,
  required String isha,
}) {
  return PrayerDay(
    date: date,
    timezone: timezone,
    method: 'Diyanet',
    fajr: fajr,
    sunrise: '07:00',
    dhuhr: dhuhr,
    asr: asr,
    maghrib: maghrib,
    isha: isha,
  );
}

void main() {
  tz_data.initializeTimeZones();

  final PrayerLogicService service = PrayerLogicService();

  test('returns Dhuhr as current and Asr as next during afternoon', () {
    final PrayerDay today = buildDay(
      date: DateTime.utc(2026, 3, 3),
      timezone: 'Europe/Istanbul',
      fajr: '06:00',
      dhuhr: '13:00',
      asr: '16:30',
      maghrib: '19:10',
      isha: '20:25',
    );

    final PrayerStatus status = service.resolvePrayerStatus(
      timestamp: DateTime.parse('2026-03-03T11:00:00Z'),
      today: today,
    );

    expect(status.currentPrayer, PrayerName.dhuhr);
    expect(status.nextPrayer, PrayerName.asr);
    expect(status.remainingToNext, const Duration(hours: 2, minutes: 30));
  });

  test('after Isha transitions to next-day Fajr', () {
    final PrayerDay today = buildDay(
      date: DateTime.utc(2026, 3, 3),
      timezone: 'Europe/Istanbul',
      fajr: '06:00',
      dhuhr: '13:00',
      asr: '16:30',
      maghrib: '19:10',
      isha: '20:25',
    );
    final PrayerDay tomorrow = buildDay(
      date: DateTime.utc(2026, 3, 4),
      timezone: 'Europe/Istanbul',
      fajr: '05:58',
      dhuhr: '13:00',
      asr: '16:31',
      maghrib: '19:11',
      isha: '20:26',
    );

    final PrayerStatus status = service.resolvePrayerStatus(
      timestamp: DateTime.parse('2026-03-03T19:30:00Z'),
      today: today,
      tomorrow: tomorrow,
    );

    expect(status.currentPrayer, PrayerName.isha);
    expect(status.nextPrayer, PrayerName.fajr);
    expect(status.remainingToNext, const Duration(hours: 7, minutes: 28));
  });

  test('before Fajr treats current as Isha and next as Fajr', () {
    final PrayerDay today = buildDay(
      date: DateTime.utc(2026, 3, 3),
      timezone: 'Europe/Istanbul',
      fajr: '06:00',
      dhuhr: '13:00',
      asr: '16:30',
      maghrib: '19:10',
      isha: '20:25',
    );

    final PrayerStatus status = service.resolvePrayerStatus(
      timestamp: DateTime.parse('2026-03-03T02:00:00Z'),
      today: today,
    );

    expect(status.currentPrayer, PrayerName.isha);
    expect(status.nextPrayer, PrayerName.fajr);
    expect(status.remainingToNext, const Duration(hours: 1));
  });

  test('handles DST day in Europe/London correctly', () {
    final PrayerDay today = buildDay(
      date: DateTime.utc(2026, 3, 29),
      timezone: 'Europe/London',
      fajr: '04:30',
      dhuhr: '13:10',
      asr: '16:40',
      maghrib: '19:25',
      isha: '20:50',
    );

    final PrayerStatus status = service.resolvePrayerStatus(
      timestamp: DateTime.parse('2026-03-29T12:30:00Z'),
      today: today,
    );

    expect(status.currentPrayer, PrayerName.dhuhr);
    expect(status.nextPrayer, PrayerName.asr);
    expect(status.remainingToNext, const Duration(hours: 3, minutes: 10));
  });

  test(
    'countdown stream decreases and reaches zero with fake clock',
    () async {
      final DateTime base = DateTime.utc(2030, 1, 1, 12, 0, 0);
      int callCount = 0;
      final List<DateTime> fakeTimes = <DateTime>[
        base.subtract(const Duration(seconds: 10)),
        base.subtract(const Duration(seconds: 5)),
        base.add(const Duration(seconds: 1)),
      ];

      final List<Duration> values = await service
          .countdownStream(
            nextPrayerAt: base,
            timezone: 'UTC',
            interval: const Duration(milliseconds: 1),
            nowProvider: () => fakeTimes[callCount++],
          )
          .toList();

      expect(values, hasLength(3));
      expect(values[0], const Duration(seconds: 10));
      expect(values[1], const Duration(seconds: 5));
      expect(values[2], Duration.zero);
    },
  );

  test('countdownStream emits ArgumentError for non-positive interval',
      () async {
    await expectLater(
      service.countdownStream(
        nextPrayerAt: DateTime.utc(2030),
        timezone: 'UTC',
        interval: Duration.zero,
      ),
      emitsError(isA<ArgumentError>()),
    );
  });
}
