# Design System Implementation Notes

## Objective
Provide a stable code architecture that keeps UI decisions centralized and reusable.

## Code Ownership
- Theme/tokens: `project_code/lib/app/theme/`
- App shell/navigation: `project_code/lib/app/`
- Design preview and reusable UI examples: `project_code/lib/features/design_preview/`

## Required APIs
- `AppTokens`: spacing, shape, elevation, motion, sizing.
- `AppColorRoles`: semantic color roles and light/dark role builders.
- `AppTypography.resolve(Locale)`: locale-aware typography mapping.
- `AppBreakpoints`: compact/medium/expanded boundaries.
- `AppTheme.buildLightTheme()`: centralized ThemeData.

## Enforcement Path
- `tool/design_guard.dart` checks token/theming policy violations.
- GitHub Actions workflow runs:
  - doc check
  - flutter analyze
  - design guard
  - design tests
  - golden tests

## Branch Protection Recommendation
For branch `renew`, require the following status checks before merge:
- `design-checklist-doc-check`
- `flutter-static-check`
- `design-guard-check`
- `design-tests`
- `golden-tests`

Also enable:
- Dismiss stale pull request approvals when new commits are pushed.

## Extension Rules
When adding new UI:
1. Start with existing components/tokens.
2. If a new component is needed, document it first.
3. Add tests and goldens for visual contracts.
4. Ensure CI design gate passes before merge.
