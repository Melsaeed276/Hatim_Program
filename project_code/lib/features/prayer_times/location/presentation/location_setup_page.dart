import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../data/firestore_location_profile_repository.dart';
import '../data/flutter_timezone_service.dart';
import '../data/geocoding_service.dart';
import '../data/geolocator_location_service.dart';
import '../domain/location_models.dart';
import 'location_setup_controller.dart';

class LocationSetupPage extends StatefulWidget {
  const LocationSetupPage({super.key, this.controller});

  final LocationSetupController? controller;

  @override
  State<LocationSetupPage> createState() => _LocationSetupPageState();
}

class _LocationSetupPageState extends State<LocationSetupPage> {
  late final LocationSetupController _controller;
  late final bool _ownsController;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _timezoneController = TextEditingController();

  List<String> _availableTimezones = const <String>[];

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        LocationSetupController(
          locationService: const GeolocatorLocationService(),
          geocodingService: const GeocodingServiceImpl(),
          timezoneService: FlutterTimezoneService(),
          locationProfileRepository: FirestoreLocationProfileRepository(
            firestore: FirebaseFirestore.instance,
            firebaseAuth: FirebaseAuth.instance,
          ),
        );
    _controller.loadSavedLocation();
    _loadTimezones();
  }

  Future<void> _loadTimezones() async {
    final List<String> values = await _controller.loadAvailableTimezones();
    if (!mounted) {
      return;
    }
    setState(() {
      _availableTimezones = values;
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    _timezoneController.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Location Setup')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          final LocationSetupState state = _controller.state;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Set your location for prayer times',
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTokens.spaceMd),
                Text(
                  'Use GPS or enter your city and choose timezone.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTokens.spaceLg),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTokens.spaceMd),
                    child: Text(
                      state.errorMessage!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                if (state.savedLocation != null)
                  _SavedLocationCard(location: state.savedLocation!),
                if (state.savedLocation != null)
                  const SizedBox(height: AppTokens.spaceLg),
                FilledButton(
                  onPressed: state.isBusy
                      ? null
                      : _controller.useCurrentLocation,
                  child: const Text('Use current location'),
                ),
                const SizedBox(height: AppTokens.spaceSm),
                OutlinedButton(
                  onPressed: state.isBusy ? null : _controller.showManualForm,
                  child: const Text('Enter location manually'),
                ),
                if (state.isBusy)
                  const Padding(
                    padding: EdgeInsets.only(top: AppTokens.spaceMd),
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(height: AppTokens.spaceLg),
                if (state.isManualFormVisible) ...<Widget>[
                  TextField(
                    key: const Key('manual-city-field'),
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      hintText: 'Istanbul',
                    ),
                  ),
                  const SizedBox(height: AppTokens.spaceMd),
                  TextField(
                    key: const Key('manual-country-field'),
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country (optional)',
                      hintText: 'Turkey',
                    ),
                  ),
                  const SizedBox(height: AppTokens.spaceMd),
                  _TimezoneAutocompleteField(
                    controller: _timezoneController,
                    timezones: _availableTimezones,
                  ),
                  const SizedBox(height: AppTokens.spaceMd),
                  FilledButton(
                    onPressed: state.isBusy
                        ? null
                        : () {
                            _controller.saveManualLocation(
                              city: _cityController.text,
                              country: _countryController.text,
                              selectedTimezone: _timezoneController.text,
                            );
                          },
                    child: const Text('Save manual location'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TimezoneAutocompleteField extends StatelessWidget {
  const _TimezoneAutocompleteField({
    required this.controller,
    required this.timezones,
  });

  final TextEditingController controller;
  final List<String> timezones;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final String query = value.text.trim().toLowerCase();
        if (query.isEmpty) {
          return timezones.take(20);
        }
        return timezones.where(
          (String timezone) => timezone.toLowerCase().contains(query),
        );
      },
      onSelected: (String value) {
        controller.text = value;
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            textEditingController.text = controller.text;
            textEditingController.selection = TextSelection.fromPosition(
              TextPosition(offset: textEditingController.text.length),
            );

            return TextField(
              key: const Key('manual-timezone-field'),
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (String value) {
                controller.text = value;
              },
              decoration: const InputDecoration(
                labelText: 'Timezone (optional)',
                hintText: 'Europe/Istanbul',
                helperText:
                    'Select from list or leave empty to detect by city.',
              ),
            );
          },
    );
  }
}

class _SavedLocationCard extends StatelessWidget {
  const _SavedLocationCard({required this.location});

  final UserLocationProfile location;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Saved location', style: textTheme.titleMedium),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              '${location.city}, ${location.country}',
              style: textTheme.bodyMedium,
            ),
            Text('Timezone: ${location.timezone}', style: textTheme.bodyMedium),
            Text(
              'Coordinates: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
              style: textTheme.bodyMedium,
            ),
            Text(
              'Source: ${location.source.name}',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
