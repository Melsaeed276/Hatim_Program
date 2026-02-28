# Design QA Checklist

Use this checklist for any PR touching UI.

## A. Documentation
- [ ] Design changes align with `docs/design-system.md`.
- [ ] New/updated components are documented in `docs/design-system/components.md`.
- [ ] Screen-level behavior updates are reflected in `docs/design-system/screens.md`.

## B. Theming and Tokens
- [ ] UI uses `AppTheme` and token APIs.
- [ ] No hardcoded `Color(...)` or `Colors.*` in feature widgets.
- [ ] Text styling uses theme/typography helpers.

## C. Accessibility
- [ ] Interactive controls satisfy 48x48 touch target guidance.
- [ ] Semantics labels/roles are present for actionable controls.
- [ ] Loading/empty/error states are understandable.

## D. Localization and RTL
- [ ] EN, TR, and AR layouts verified.
- [ ] RTL behavior verified for Arabic.
- [ ] No clipping/overflow for longer localized strings.

## E. Responsiveness
- [ ] Compact layout verified.
- [ ] Medium layout behavior verified.
- [ ] Expanded behavior remains readable and stable.

## F. Testing
- [ ] Design-tagged widget tests pass.
- [ ] Golden tests updated/passed for changed design preview or shared components.
- [ ] CI design compliance workflow passes.
