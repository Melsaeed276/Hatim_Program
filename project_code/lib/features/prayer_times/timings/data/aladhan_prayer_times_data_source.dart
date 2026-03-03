import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/prayer_day.dart';
import '../domain/prayer_times_data_source.dart';
import '../domain/prayer_times_failure.dart';

class AlAdhanPrayerTimesDataSource implements PrayerTimesDataSource {
  AlAdhanPrayerTimesDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  String get providerId => 'aladhan';

  @override
  Future<List<PrayerDay>> fetchMonthlyCalendar({
    required int year,
    required int month,
    required String city,
    required String country,
    required int method,
  }) async {
    if (city.trim().isEmpty || country.trim().isEmpty) {
      throw const PrayerTimesFailure(
        PrayerTimesFailureType.invalidLocation,
        'City and country are required for prayer-time lookup.',
      );
    }

    final Uri uri =
        Uri.parse(
          'https://api.aladhan.com/v1/calendarByCity/$year/$month',
        ).replace(
          queryParameters: <String, String>{
            'city': city.trim(),
            'country': country.trim(),
            'method': '$method',
          },
        );

    http.Response response;
    try {
      response = await _client.get(uri);
    } catch (_) {
      throw const PrayerTimesFailure(
        PrayerTimesFailureType.network,
        'Failed to connect to AlAdhan API.',
      );
    }

    if (response.statusCode != 200) {
      throw PrayerTimesFailure(
        PrayerTimesFailureType.providerUnavailable,
        'AlAdhan returned status ${response.statusCode}.',
      );
    }

    try {
      final Map<String, dynamic> payload =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> data = payload['data'] as List<dynamic>;

      return data
          .map((dynamic item) {
            final Map<String, dynamic> record = item as Map<String, dynamic>;
            final Map<String, dynamic> timings =
                record['timings'] as Map<String, dynamic>;
            final Map<String, dynamic> meta =
                record['meta'] as Map<String, dynamic>;
            final Map<String, dynamic> methodMap =
                meta['method'] as Map<String, dynamic>;
            final Map<String, dynamic> date =
                record['date'] as Map<String, dynamic>;
            final Map<String, dynamic> gregorian =
                date['gregorian'] as Map<String, dynamic>;

            return PrayerDay(
              date: _parseDate(gregorian['date'] as String),
              timezone: '${meta['timezone']}',
              method: '${methodMap['name']}',
              fajr: _normalizeTime('${timings['Fajr']}'),
              sunrise: _normalizeTime('${timings['Sunrise']}'),
              dhuhr: _normalizeTime('${timings['Dhuhr']}'),
              asr: _normalizeTime('${timings['Asr']}'),
              maghrib: _normalizeTime('${timings['Maghrib']}'),
              isha: _normalizeTime('${timings['Isha']}'),
            );
          })
          .toList(growable: false);
    } catch (_) {
      throw const PrayerTimesFailure(
        PrayerTimesFailureType.parsing,
        'Could not parse AlAdhan response.',
      );
    }
  }

  DateTime _parseDate(String rawDate) {
    final List<String> parts = rawDate.split('-');
    if (parts.length != 3) {
      throw const FormatException('Invalid Gregorian date format.');
    }
    return DateTime.utc(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  String _normalizeTime(String raw) {
    final String normalized = raw.split(' ').first.trim();
    if (normalized.length < 4) {
      throw const FormatException('Invalid prayer-time value.');
    }
    return normalized;
  }
}
