import 'dart:convert';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;

import '../domain/location_services.dart';

class FlutterTimezoneService implements TimezoneService {
  FlutterTimezoneService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<String> resolveLocalTimezone() async {
    final String timezone = await FlutterTimezone.getLocalTimezone();
    if (timezone.isEmpty) {
      return 'UTC';
    }
    return timezone;
  }

  @override
  Future<String> resolveTimezoneForCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.parse('https://api.aladhan.com/v1/timings').replace(
      queryParameters: <String, String>{
        'latitude': '$latitude',
        'longitude': '$longitude',
        'method': '13',
      },
    );

    try {
      final http.Response response = await _client.get(uri);
      if (response.statusCode != 200) {
        return resolveLocalTimezone();
      }

      final Map<String, dynamic> payload =
          jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic>? data =
          payload['data'] as Map<String, dynamic>?;
      final Map<String, dynamic>? meta = data?['meta'] as Map<String, dynamic>?;
      final String timezone = '${meta?['timezone'] ?? ''}'.trim();
      if (timezone.isEmpty) {
        return resolveLocalTimezone();
      }
      return timezone;
    } catch (_) {
      return resolveLocalTimezone();
    }
  }

  @override
  Future<List<String>> getAvailableTimezones() async {
    final List<String> values = await FlutterTimezone.getAvailableTimezones();
    if (values.isEmpty) {
      return const <String>['UTC'];
    }
    return values;
  }
}
