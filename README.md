# Hatim Program

Hatim Program is being rebuilt as an Islamic mobile-first Flutter app.

Current target: deliver a clean MVP centered on prayer-time experience, then add additional Islamic features incrementally.

## MVP Scope (Current Plan)
- Prayer times for user location.
- Current prayer, next prayer, and remaining time countdown.
- Prayer reminder notifications.
- Auth with phone or Google.
- User settings for prayer-time calculation preferences.

## Tech Stack
- Flutter (app client)
- Firebase Auth (phone + Google sign-in)
- Cloud Firestore (user profile + settings)
- Local persistence/cache in app for offline prayer-time experience

## Repository Layout
- `project_code/`: Flutter application source.
- `docs/`: project architecture, Firebase, and contribution docs.
- `.github/`: GitHub workflows.

## Getting Started
1. Open the Flutter app directory:
   ```bash
   cd project_code
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
4. Run tests:
   ```bash
   flutter test
   ```

## Firebase Setup (Planned Baseline)
1. Create a Firebase project.
2. Enable Authentication providers:
   - Phone
   - Google
3. Enable Firestore.
4. Configure FlutterFire from `project_code/`:
   ```bash
   flutterfire configure
   ```

## Documentation
- Architecture: `docs/architecture.md`
- Firebase: `docs/firebase.md`
- Contributing: `docs/contributing.md`
- Prayer-time API decision: `docs/prayer-time-api-decision.md`
