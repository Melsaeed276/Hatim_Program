import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/prayer_times/timings/data/aladhan_prayer_times_data_source.dart';
import 'package:hatim_program/features/prayer_times/timings/domain/prayer_times_failure.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('maps monthly response to normalized prayer day', () async {
    final MockClient client = MockClient((http.Request request) async {
      final Map<String, dynamic> payload = <String, dynamic>{
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            'timings': <String, String>{
              'Fajr': '06:04 (+03)',
              'Sunrise': '07:28 (+03)',
              'Dhuhr': '13:20 (+03)',
              'Asr': '16:30 (+03)',
              'Maghrib': '19:10 (+03)',
              'Isha': '20:25 (+03)',
            },
            'date': <String, dynamic>{
              'gregorian': <String, String>{'date': '03-03-2026'},
            },
            'meta': <String, dynamic>{
              'timezone': 'Europe/Istanbul',
              'method': <String, dynamic>{'name': 'Diyanet'},
            },
          },
        ],
      };
      return http.Response(jsonEncode(payload), 200);
    });

    final AlAdhanPrayerTimesDataSource dataSource =
        AlAdhanPrayerTimesDataSource(client: client);

    final days = await dataSource.fetchMonthlyCalendar(
      year: 2026,
      month: 3,
      city: 'Istanbul',
      country: 'Turkey',
      method: 13,
    );

    expect(days, hasLength(1));
    expect(days.first.fajr, '06:04');
    expect(days.first.isha, '20:25');
    expect(days.first.timezone, 'Europe/Istanbul');
    expect(days.first.date, DateTime.utc(2026, 3, 3));
  });

  test('throws invalid location failure on empty city/country', () async {
    final AlAdhanPrayerTimesDataSource dataSource =
        AlAdhanPrayerTimesDataSource(
          client: MockClient(
            (http.Request request) async => http.Response('{}', 200),
          ),
        );

    expect(
      () => dataSource.fetchMonthlyCalendar(
        year: 2026,
        month: 3,
        city: '',
        country: 'Turkey',
        method: 13,
      ),
      throwsA(
        isA<PrayerTimesFailure>().having(
          (PrayerTimesFailure error) => error.type,
          'type',
          PrayerTimesFailureType.invalidLocation,
        ),
      ),
    );
  });

  test('throws provider unavailable on non-200 status', () async {
    final AlAdhanPrayerTimesDataSource dataSource =
        AlAdhanPrayerTimesDataSource(
          client: MockClient(
            (http.Request request) async => http.Response('down', 503),
          ),
        );

    expect(
      () => dataSource.fetchMonthlyCalendar(
        year: 2026,
        month: 3,
        city: 'Istanbul',
        country: 'Turkey',
        method: 13,
      ),
      throwsA(
        isA<PrayerTimesFailure>().having(
          (PrayerTimesFailure error) => error.type,
          'type',
          PrayerTimesFailureType.providerUnavailable,
        ),
      ),
    );
  });
}
