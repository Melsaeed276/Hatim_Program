import 'location_models.dart';

enum LocationPermissionStatus {
  unknown,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

abstract class LocationService {
  Future<bool> isServiceEnabled();

  Future<LocationPermissionStatus> checkPermission();

  Future<LocationPermissionStatus> requestPermission();

  Future<Coordinates> getCurrentCoordinates();
}

abstract class GeocodingService {
  Future<PlaceDetails> reverseGeocode(Coordinates coordinates);

  Future<Coordinates> geocodeQuery({required String query});

  Future<Coordinates> geocodeCityCountry({
    required String city,
    required String country,
  });
}

abstract class TimezoneService {
  Future<String> resolveLocalTimezone();

  Future<String> resolveTimezoneForCoordinates({
    required double latitude,
    required double longitude,
  });

  Future<List<String>> getAvailableTimezones();
}

abstract class LocationProfileRepository {
  Future<UserLocationProfile?> loadLocation();

  Future<void> saveLocation(UserLocationProfile location);
}
