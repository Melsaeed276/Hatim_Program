# Firebase Plan

## Goal
Define Firebase usage for auth, user profile, and prayer-time settings for the rebuilt app.

## Firebase Services
- Firebase Authentication
  - Phone authentication
  - Google authentication
- Cloud Firestore
  - User profile and user settings
- Firebase Cloud Messaging (planned)
  - Token registration for future remote messaging use-cases

## High-Level Data Model

### `users/{uid}`
```json
{
  "uid": "string",
  "name": "string",
  "phoneNumber": "string|null",
  "referenceCode": "string|null",
  "authProviders": ["phone", "google"],
  "passwordEnabled": true,
  "passwordHash": "string|null",
  "location": {
    "city": "string|null",
    "country": "string|null",
    "latitude": 0.0,
    "longitude": 0.0,
    "timeZone": "Europe/Istanbul"
  },
  "prayerSettings": {
    "method": 13,
    "madhab": "hanafi",
    "highLatitudeRule": "middle_of_night",
    "timeFormat24h": true,
    "adjustments": {
      "fajr": 0,
      "dhuhr": 0,
      "asr": 0,
      "maghrib": 0,
      "isha": 0
    },
    "notifications": {
      "fajr": true,
      "dhuhr": true,
      "asr": true,
      "maghrib": true,
      "isha": true,
      "offsetMinutes": 10
    }
  },
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

## Security Notes
- Do not store raw passwords in Firestore.
- If custom password flow is required, hash + verify through a trusted backend path (for example Cloud Functions), not plain client writes.
- Enforce owner-only access on user document:
  - read/write only when `request.auth.uid == uid`.

## Firestore Rules Baseline (Intent)
- Users can read/write only their own `users/{uid}` document.
- No public write access.
- Server-managed timestamps for audit fields where possible.

## Provider Decision Context
- Primary prayer-time provider target: AlAdhan API.
- Turkey/Diyanet method target: `method=13`.
- Keep provider abstraction for fallback adapters.
