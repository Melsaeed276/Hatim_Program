import 'package:geolocator/geolocator.dart';

import '../domain/location_models.dart';
import '../domain/location_services.dart';

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermissionStatus> checkPermission() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    return _mapPermission(permission);
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    return _mapPermission(permission);
  }

  @override
  Future<Coordinates> getCurrentCoordinates() async {
    final Position position = await Geolocator.getCurrentPosition();
    return Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.granted;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unknown;
    }
  }
}
