import 'package:timezone/timezone.dart' as tz;

import 'prayer_day.dart';

enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

class PrayerStatus {
  const PrayerStatus({
    required this.currentPrayer,
    required this.nextPrayer,
    required this.nextPrayerAt,
    required this.remainingToNext,
    required this.timezone,
  });

  final PrayerName currentPrayer;
  final PrayerName nextPrayer;
  final DateTime nextPrayerAt;
  final Duration remainingToNext;
  final String timezone;
}

class PrayerLogicService {
  PrayerLogicService({tz.Location Function(String timezone)? locationResolver})
    : _locationResolver = locationResolver ?? tz.getLocation;

  final tz.Location Function(String timezone) _locationResolver;

  PrayerStatus resolvePrayerStatus({
    required DateTime timestamp,
    required PrayerDay today,
    PrayerDay? tomorrow,
  }) {
    final tz.Location location = _locationResolver(today.timezone);
    final tz.TZDateTime now = tz.TZDateTime.from(timestamp, location);
    final List<_PrayerEvent> eventsToday = _buildPrayerEvents(today, location);

    if (now.isBefore(eventsToday.first.at)) {
      final _PrayerEvent next = eventsToday.first;
      return PrayerStatus(
        currentPrayer: PrayerName.isha,
        nextPrayer: next.prayer,
        nextPrayerAt: next.at,
        remainingToNext: next.at.difference(now),
        timezone: today.timezone,
      );
    }

    for (int index = 0; index < eventsToday.length - 1; index += 1) {
      final _PrayerEvent current = eventsToday[index];
      final _PrayerEvent next = eventsToday[index + 1];
      if (!now.isBefore(current.at) && now.isBefore(next.at)) {
        return PrayerStatus(
          currentPrayer: current.prayer,
          nextPrayer: next.prayer,
          nextPrayerAt: next.at,
          remainingToNext: next.at.difference(now),
          timezone: today.timezone,
        );
      }
    }

    final _PrayerEvent todayIsha = eventsToday.last;
    final tz.TZDateTime nextFajrTime = _nextDayFajr(
      location: location,
      today: today,
      tomorrow: tomorrow,
    );
    return PrayerStatus(
      currentPrayer: todayIsha.prayer,
      nextPrayer: PrayerName.fajr,
      nextPrayerAt: nextFajrTime,
      remainingToNext: nextFajrTime.difference(now),
      timezone: today.timezone,
    );
  }

  Stream<Duration> countdownStream({
    required DateTime nextPrayerAt,
    required String timezone,
    Duration interval = const Duration(minutes: 1),
    DateTime Function()? nowProvider,
  }) async* {
    final DateTime Function() clock = nowProvider ?? DateTime.now;
    while (true) {
      final tz.Location location = _locationResolver(timezone);
      final tz.TZDateTime now = tz.TZDateTime.from(clock(), location);
      final tz.TZDateTime target = tz.TZDateTime.from(nextPrayerAt, location);
      final Duration remaining = target.difference(now);
      if (remaining <= Duration.zero) {
        yield Duration.zero;
        break;
      }

      yield remaining;
      await Future<void>.delayed(interval);
    }
  }

  List<_PrayerEvent> _buildPrayerEvents(PrayerDay day, tz.Location location) {
    final int year = day.date.year;
    final int month = day.date.month;
    final int date = day.date.day;
    return <_PrayerEvent>[
      _PrayerEvent(
        prayer: PrayerName.fajr,
        at: _at(location, year, month, date, day.fajr),
      ),
      _PrayerEvent(
        prayer: PrayerName.dhuhr,
        at: _at(location, year, month, date, day.dhuhr),
      ),
      _PrayerEvent(
        prayer: PrayerName.asr,
        at: _at(location, year, month, date, day.asr),
      ),
      _PrayerEvent(
        prayer: PrayerName.maghrib,
        at: _at(location, year, month, date, day.maghrib),
      ),
      _PrayerEvent(
        prayer: PrayerName.isha,
        at: _at(location, year, month, date, day.isha),
      ),
    ];
  }

  tz.TZDateTime _nextDayFajr({
    required tz.Location location,
    required PrayerDay today,
    required PrayerDay? tomorrow,
  }) {
    if (tomorrow != null) {
      return _at(
        location,
        tomorrow.date.year,
        tomorrow.date.month,
        tomorrow.date.day,
        tomorrow.fajr,
      );
    }

    final List<int> parts = _parseTime(today.fajr);
    final tz.TZDateTime nextDay = tz.TZDateTime(
      location,
      today.date.year,
      today.date.month,
      today.date.day + 1,
      parts[0],
      parts[1],
    );
    return nextDay;
  }

  tz.TZDateTime _at(
    tz.Location location,
    int year,
    int month,
    int day,
    String time,
  ) {
    final List<int> parsed = _parseTime(time);
    return tz.TZDateTime(location, year, month, day, parsed[0], parsed[1]);
  }

  List<int> _parseTime(String raw) {
    final List<String> parts = raw.split(':');
    if (parts.length != 2) {
      throw const FormatException('Expected HH:mm prayer time.');
    }
    return <int>[int.parse(parts[0]), int.parse(parts[1])];
  }
}

class _PrayerEvent {
  const _PrayerEvent({required this.prayer, required this.at});

  final PrayerName prayer;
  final tz.TZDateTime at;
}
