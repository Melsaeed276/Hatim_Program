import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/prayer_times/location/domain/location_models.dart';
import 'package:hatim_program/features/prayer_times/location/domain/location_services.dart';
import 'package:hatim_program/features/prayer_times/location/presentation/location_setup_controller.dart';
import 'package:hatim_program/features/prayer_times/location/presentation/location_setup_page.dart';

class FakeLocationService implements LocationService {
  @override
  Future<LocationPermissionStatus> checkPermission() async {
    return LocationPermissionStatus.denied;
  }

  @override
  Future<Coordinates> getCurrentCoordinates() async {
    return const Coordinates(latitude: 41.0082, longitude: 28.9784);
  }

  @override
  Future<bool> isServiceEnabled() async => true;

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    return LocationPermissionStatus.denied;
  }
}

class FakeGeocodingService implements GeocodingService {
  @override
  Future<Coordinates> geocodeQuery({required String query}) async {
    return const Coordinates(latitude: 41.01, longitude: 28.97);
  }

  @override
  Future<Coordinates> geocodeCityCountry({
    required String city,
    required String country,
  }) async {
    return const Coordinates(latitude: 41.01, longitude: 28.97);
  }

  @override
  Future<PlaceDetails> reverseGeocode(Coordinates coordinates) async {
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
  @override
  Future<UserLocationProfile?> loadLocation() async => null;

  @override
  Future<void> saveLocation(UserLocationProfile location) async {}
}

void main() {
  testWidgets('denied permission reveals manual form and validates fields', (
    WidgetTester tester,
  ) async {
    final LocationSetupController controller = LocationSetupController(
      locationService: FakeLocationService(),
      geocodingService: FakeGeocodingService(),
      timezoneService: FakeTimezoneService(),
      locationProfileRepository: InMemoryLocationProfileRepository(),
    );

    await tester.pumpWidget(
      MaterialApp(home: LocationSetupPage(controller: controller)),
    );
    await tester.pump();

    await tester.tap(find.text('Use current location'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('manual-city-field')), findsOneWidget);
    expect(find.byKey(const Key('manual-country-field')), findsOneWidget);
    expect(find.byKey(const Key('manual-timezone-field')), findsOneWidget);

    await tester.ensureVisible(find.text('Save manual location'));
    await tester.tap(find.text('Save manual location'));
    await tester.pumpAndSettle();

    expect(find.text('City is required for manual location.'), findsOneWidget);
  });
}
