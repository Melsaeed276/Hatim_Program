# Architecture

## Goal
Define a maintainable structure for the new app so features can ship independently without tight coupling.

## Architecture Style
- Feature-first structure.
- Clean boundaries between `presentation`, `domain`, and `data`.
- Dependency direction: `presentation -> domain -> data`.
- Shared cross-feature utilities live in `core/` and `shared/`.

## Proposed `lib/` Structure
```text
lib/
  main.dart
  app/
    app.dart
    bootstrap.dart
  core/
    constants/
    errors/
    services/
    utils/
  shared/
    widgets/
    theme/
    models/
  features/
    auth/
      presentation/
      domain/
      data/
    prayer_times/
      presentation/
      domain/
      data/
    settings/
      presentation/
      domain/
      data/
```

## Module Boundaries
- `features/auth`
  - Owns sign-up/login/session flows.
  - Owns profile identity fields (name, phone, reference code, providers).
- `features/prayer_times`
  - Owns prayer-time fetching, cache, current/next prayer logic, countdown, reminders.
- `features/settings`
  - Owns prayer calculation method preferences and notification toggles.
- `core`
  - Cross-cutting concerns only (network client, error types, time helpers, logging).
- `shared`
  - Reusable UI widgets and design primitives only.

## Dependency Rules
- A feature must not import another feature's `data` layer directly.
- Cross-feature calls happen via domain contracts/interfaces.
- External packages are wrapped behind adapters in `data` or `core/services`.

## Delivery Strategy
- Start with vertical slices: each issue should add presentation + domain + data for one user-visible capability.
- Keep PRs small and issue-linked.
