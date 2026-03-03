import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/prayer_times/location/domain/location_models.dart';
import 'package:hatim_program/features/prayer_times/location/domain/location_services.dart';
import 'package:hatim_program/features/prayer_times/location/presentation/location_setup_controller.dart';

class FakeLocationService implements LocationService {
  FakeLocationService({
    required this.permission,
    this.serviceEnabled = true,
    this.coordinates = const Coordinates(latitude: 41.0082, longitude: 28.9784),
  });

  LocationPermissionStatus permission;
  bool serviceEnabled;
  Coordinates coordinates;

  @override
  Future<LocationPermissionStatus> checkPermission() async => permission;

  @override
  Future<Coordinates> getCurrentCoordinates() async => coordinates;

  @override
  Future<bool> isServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermissionStatus> requestPermission() async => permission;
}

class FakeGeocodingService implements GeocodingService {
  FakeGeocodingService({this.throwOnReverse = false});

  final bool throwOnReverse;

  @override
  Future<Coordinates> geocodeQuery({required String query}) async {
    if (query.contains('invalid')) {
      throw StateError('invalid');
    }
    return const Coordinates(latitude: 41.01, longitude: 28.97);
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
    if (throwOnReverse) {
      throw StateError('reverse-failed');
    }
    return const PlaceDetails(city: 'Istanbul', country: 'Turkey');
  }
}

class FakeTimezoneService implements TimezoneService {
  @override
  Future<String> resolveLocalTimezone() async => 'Europe/Istanbul';

  @override
  Future<String> resolveTimezoneForCoordinates({
    required double latitude,
    required double longitude,
  }) async => 'Europe/Istanbul';

  @override
  Future<List<String>> getAvailableTimezones() async {
    return const <String>['Europe/Istanbul', 'UTC'];
  }
}

class InMemoryLocationProfileRepository implements LocationProfileRepository {
  UserLocationProfile? saved;

  @override
  Future<UserLocationProfile?> loadLocation() async => saved;

  @override
  Future<void> saveLocation(UserLocationProfile location) async {
    saved = location;
  }
}

void main() {
  test('denied permission shows manual form and error', () async {
    final FakeLocationService locationService = FakeLocationService(
      permission: LocationPermissionStatus.denied,
    );
    final InMemoryLocationProfileRepository repository =
        InMemoryLocationProfileRepository();

    final LocationSetupController controller = LocationSetupController(
      locationService: locationService,
      geocodingService: FakeGeocodingService(),
      timezoneService: FakeTimezoneService(),
      locationProfileRepository: repository,
    );

    await controller.useCurrentLocation();

    expect(controller.state.isManualFormVisible, isTrue);
    expect(controller.state.errorMessage, isNotNull);
    expect(repository.saved, isNull);
  });

  test('manual save persists city, country and coordinates', () async {
    final InMemoryLocationProfileRepository repository =
        InMemoryLocationProfileRepository();

    final LocationSetupController controller = LocationSetupController(
      locationService: FakeLocationService(
        permission: LocationPermissionStatus.granted,
      ),
      geocodingService: FakeGeocodingService(),
      timezoneService: FakeTimezoneService(),
      locationProfileRepository: repository,
    );

    await controller.saveManualLocation(
      city: 'Istanbul',
      country: 'Turkey',
      selectedTimezone: 'Europe/Istanbul',
    );

    expect(repository.saved, isNotNull);
    expect(repository.saved!.city, 'Istanbul');
    expect(repository.saved!.country, 'Turkey');
    expect(repository.saved!.source, LocationSource.manual);
  });

  test('empty manual fields return validation error', () async {
    final LocationSetupController controller = LocationSetupController(
      locationService: FakeLocationService(
        permission: LocationPermissionStatus.granted,
      ),
      geocodingService: FakeGeocodingService(),
      timezoneService: FakeTimezoneService(),
      locationProfileRepository: InMemoryLocationProfileRepository(),
    );

    await controller.saveManualLocation(
      city: ' ',
      country: 'Turkey',
      selectedTimezone: '',
    );

    expect(
      controller.state.errorMessage,
      'City is required for manual location.',
    );
  });

  test('auto location still saves when reverse geocoding fails', () async {
    final InMemoryLocationProfileRepository repository =
        InMemoryLocationProfileRepository();

    final LocationSetupController controller = LocationSetupController(
      locationService: FakeLocationService(
        permission: LocationPermissionStatus.granted,
      ),
      geocodingService: FakeGeocodingService(throwOnReverse: true),
      timezoneService: FakeTimezoneService(),
      locationProfileRepository: repository,
    );

    await controller.useCurrentLocation();

    expect(repository.saved, isNotNull);
    expect(repository.saved!.timezone, 'Europe/Istanbul');
    expect(repository.saved!.city, 'Unknown');
  });
}
