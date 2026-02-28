# MVP Screen Specs

## 1. Onboarding / Entry
### Goal
Introduce app purpose quickly and route user to authentication.

### Structure
- App title and short message.
- Primary action: Continue.
- Secondary action: Sign in with Google (optional surface here if product keeps it on auth only).
- Locale switch affordance (EN/AR/TR).

### Notes
- Keep content short and calm.
- Ensure RTL-aware spacing and alignment.

## 2. Sign Up
### Goal
Create account with phone or Google while collecting identity fields.

### Required Inputs
- Name (required)
- Phone number (required for phone flow)
- Reference code (optional)
- Password (optional; if provided, show confirm password)

### Actions
- Primary: Create account
- Secondary: Continue with Google
- Link: Already have account? Login

### Validation
- Inline, field-level validation.
- Clear phone formatting and error copy.

## 3. Login
### Goal
Authenticate returning users through phone or Google.

### Inputs and Behavior
- Phone number (required for phone flow).
- Password field appears when user profile requires password.
- Google sign-in option always visible.

### Actions
- Primary: Login
- Secondary: Continue with Google

### States
- Loading during authentication.
- Error banner/message for auth failure.

## 4. Home Prayer Dashboard
### Goal
Surface current prayer, next prayer, and remaining time at a glance.

### Main Blocks
1. Current Prayer card
2. Next Prayer card
3. Countdown block (time remaining)
4. Today prayer list (Fajr, Dhuhr, Asr, Maghrib, Isha)

### Optional Actions (MVP-friendly)
- Refresh times
- Open prayer settings

### State Handling
- Loading: dashboard skeleton or loading block.
- Empty: explicit no-data guidance.
- Error: retry path with last known data if available.

## Responsive Behavior
- Compact: single column stacking.
- Medium: grouped cards in two-column arrangement where useful.
- Expanded: maintain readability with max content width.

## Localization Behavior
- Arabic uses RTL alignment and mirrored flow.
- Typography and wrapping must handle Turkish and Arabic expansion.
