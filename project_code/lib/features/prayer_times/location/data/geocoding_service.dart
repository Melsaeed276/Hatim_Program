import 'package:geocoding/geocoding.dart';

import '../domain/location_models.dart';
import '../domain/location_services.dart';

class GeocodingServiceImpl implements GeocodingService {
  const GeocodingServiceImpl();

  @override
  Future<Coordinates> geocodeQuery({required String query}) async {
    final String normalized = query.trim();
    if (normalized.isEmpty) {
      throw StateError('Query cannot be empty.');
    }

    final List<Location> locations = await locationFromAddress(normalized);
    if (locations.isEmpty) {
      throw StateError('Unable to resolve location for $normalized.');
    }

    final Location location = locations.first;
    return Coordinates(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  @override
  Future<Coordinates> geocodeCityCountry({
    required String city,
    required String country,
  }) async {
    return geocodeQuery(query: '$city, $country');
  }

  @override
  Future<PlaceDetails> reverseGeocode(Coordinates coordinates) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );

    if (placemarks.isEmpty) {
      throw StateError('Unable to resolve city and country.');
    }

    final Placemark first = placemarks.first;
    final String city = (first.locality ?? first.administrativeArea ?? '')
        .trim();
    final String country = (first.country ?? '').trim();
    if (city.isEmpty || country.isEmpty) {
      throw StateError('Location details are incomplete.');
    }

    return PlaceDetails(city: city, country: country);
  }
}
