import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/prayer_day.dart';
import '../domain/prayer_times_cache.dart';

class SharedPrefsPrayerTimesCache implements PrayerTimesCache {
  SharedPrefsPrayerTimesCache({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  Future<CachedPrayerMonth?> read(String cacheKey) async {
    final String? encoded = _sharedPreferences.getString(_storageKey(cacheKey));
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    final Map<String, dynamic> json =
        jsonDecode(encoded) as Map<String, dynamic>;
    final List<dynamic> rows = json['days'] as List<dynamic>;
    final List<PrayerDay> days = rows
        .map((dynamic item) => PrayerDay.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    return CachedPrayerMonth(
      days: days,
      fetchedAt: DateTime.parse('${json['fetchedAt']}'),
      provider: '${json['provider']}',
    );
  }

  @override
  Future<void> write(String cacheKey, CachedPrayerMonth month) async {
    final Map<String, Object> payload = <String, Object>{
      'fetchedAt': month.fetchedAt.toUtc().toIso8601String(),
      'provider': month.provider,
      'days': month.days.map((PrayerDay day) => day.toJson()).toList(),
    };

    await _sharedPreferences.setString(
      _storageKey(cacheKey),
      jsonEncode(payload),
    );
  }

  String _storageKey(String key) => 'prayer_times_cache::$key';
}
