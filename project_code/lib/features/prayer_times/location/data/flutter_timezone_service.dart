import 'package:flutter_timezone/flutter_timezone.dart';

import '../domain/location_services.dart';

class FlutterTimezoneService implements TimezoneService {
  const FlutterTimezoneService();

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
  }) {
    return resolveLocalTimezone();
  }
}
