import 'package:flutter/foundation.dart';

import '../domain/location_models.dart';
import '../domain/location_services.dart';

class LocationSetupState {
  const LocationSetupState({
    this.isBusy = false,
    this.isManualFormVisible = false,
    this.errorMessage,
    this.savedLocation,
    this.permissionStatus = LocationPermissionStatus.unknown,
  });

  final bool isBusy;
  final bool isManualFormVisible;
  final String? errorMessage;
  final UserLocationProfile? savedLocation;
  final LocationPermissionStatus permissionStatus;

  LocationSetupState copyWith({
    bool? isBusy,
    bool? isManualFormVisible,
    String? errorMessage,
    UserLocationProfile? savedLocation,
    LocationPermissionStatus? permissionStatus,
    bool clearError = false,
  }) {
    return LocationSetupState(
      isBusy: isBusy ?? this.isBusy,
      isManualFormVisible: isManualFormVisible ?? this.isManualFormVisible,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedLocation: savedLocation ?? this.savedLocation,
      permissionStatus: permissionStatus ?? this.permissionStatus,
    );
  }
}

class LocationSetupController extends ChangeNotifier {
  LocationSetupController({
    required LocationService locationService,
    required GeocodingService geocodingService,
    required TimezoneService timezoneService,
    required LocationProfileRepository locationProfileRepository,
  }) : _locationService = locationService,
       _geocodingService = geocodingService,
       _timezoneService = timezoneService,
       _locationProfileRepository = locationProfileRepository;

  final LocationService _locationService;
  final GeocodingService _geocodingService;
  final TimezoneService _timezoneService;
  final LocationProfileRepository _locationProfileRepository;

  LocationSetupState _state = const LocationSetupState();
  LocationSetupState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadSavedLocation() async {
    _setState(_state.copyWith(isBusy: true, clearError: true));
    try {
      final UserLocationProfile? saved = await _locationProfileRepository
          .loadLocation();
      _setState(
        _state.copyWith(
          isBusy: false,
          savedLocation: saved,
          isManualFormVisible: saved == null,
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isBusy: false,
          isManualFormVisible: true,
          errorMessage: 'Could not load saved location.',
        ),
      );
    }
  }

  Future<void> useCurrentLocation() async {
    _setState(_state.copyWith(isBusy: true, clearError: true));

    final bool enabled = await _locationService.isServiceEnabled();
    if (!enabled) {
      _setState(
        _state.copyWith(
          isBusy: false,
          isManualFormVisible: true,
          permissionStatus: LocationPermissionStatus.serviceDisabled,
          errorMessage:
              'Location service is disabled. Please enter location manually.',
        ),
      );
      return;
    }

    LocationPermissionStatus permission = await _locationService
        .checkPermission();
    if (permission == LocationPermissionStatus.denied ||
        permission == LocationPermissionStatus.unknown) {
      permission = await _locationService.requestPermission();
    }

    if (permission == LocationPermissionStatus.deniedForever) {
      _setState(
        _state.copyWith(
          isBusy: false,
          isManualFormVisible: true,
          permissionStatus: permission,
          errorMessage:
              'Location permission is permanently denied. Please enable it in your device settings or continue manually.',
        ),
      );
      return;
    } else if (permission != LocationPermissionStatus.granted) {
      _setState(
        _state.copyWith(
          isBusy: false,
          isManualFormVisible: true,
          permissionStatus: permission,
          errorMessage:
              'Location permission was not granted. You can continue manually.',
        ),
      );
      return;
    }

    try {
      final Coordinates coordinates = await _locationService
          .getCurrentCoordinates();
      final PlaceDetails place = await _geocodingService.reverseGeocode(
        coordinates,
      );
      final String timezone = await _timezoneService.resolveLocalTimezone();

      final UserLocationProfile location = UserLocationProfile(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        timezone: timezone,
        city: place.city,
        country: place.country,
        source: LocationSource.gps,
        updatedAt: DateTime.now().toUtc(),
      );

      await _locationProfileRepository.saveLocation(location);

      _setState(
        _state.copyWith(
          isBusy: false,
          savedLocation: location,
          isManualFormVisible: false,
          permissionStatus: LocationPermissionStatus.granted,
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isBusy: false,
          isManualFormVisible: true,
          errorMessage:
              'Failed to resolve current location. Please enter manually.',
        ),
      );
    }
  }

  Future<void> saveManualLocation({
    required String city,
    required String country,
  }) async {
    final String normalizedCity = city.trim();
    final String normalizedCountry = country.trim();
    if (normalizedCity.isEmpty || normalizedCountry.isEmpty) {
      _setState(
        _state.copyWith(
          errorMessage: 'City and country are required.',
          isManualFormVisible: true,
        ),
      );
      return;
    }

    _setState(_state.copyWith(isBusy: true, clearError: true));

    try {
      final Coordinates coordinates = await _geocodingService
          .geocodeCityCountry(city: normalizedCity, country: normalizedCountry);
      final String timezone = await _timezoneService.resolveTimezoneForCoordinates(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );

      final UserLocationProfile location = UserLocationProfile(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        timezone: timezone,
        city: normalizedCity,
        country: normalizedCountry,
        source: LocationSource.manual,
        updatedAt: DateTime.now().toUtc(),
      );

      await _locationProfileRepository.saveLocation(location);
      _setState(
        _state.copyWith(
          isBusy: false,
          savedLocation: location,
          isManualFormVisible: true,
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isBusy: false,
          isManualFormVisible: true,
          errorMessage:
              'Could not save manual location. Check city and country.',
        ),
      );
    }
  }

  void showManualForm() {
    _setState(_state.copyWith(isManualFormVisible: true, clearError: true));
  }

  void _setState(LocationSetupState nextState) {
    if (_disposed) return;
    _state = nextState;
    notifyListeners();
  }
}
