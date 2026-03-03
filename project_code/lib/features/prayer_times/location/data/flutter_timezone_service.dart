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
  }) async {
    // A proper coordinates-based timezone lookup is not yet implemented here.
    // Failing explicitly avoids silently returning an incorrect timezone based
    // on the device settings when callers expect coordinate-based resolution.
    throw UnimplementedError(
      'resolveTimezoneForCoordinates is not implemented in FlutterTimezoneService. '
      'Callers must provide an explicit timezone or use resolveLocalTimezone().',
    );
  }
}
