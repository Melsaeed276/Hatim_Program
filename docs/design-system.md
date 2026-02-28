# Design System

## Purpose
This document defines the single reusable UI standard for Hatim Program.

The source of truth is:
1. This documentation set under `docs/design-system/`.
2. Theme/token code under `project_code/lib/app/theme/`.

Any new feature UI must follow both.

## Design Direction
- Style: clean spiritual minimal.
- Mood: calm, clear, readable, low visual noise.
- Core color direction: emerald/teal Material 3 role-based palette.
- Language support: English (LTR), Turkish (LTR), Arabic (RTL).

## Core Principles
1. Theme-driven UI only.
2. Semantic color roles only (no ad-hoc hardcoded colors).
3. Typography by script (Arabic and Latin optimized separately).
4. Accessible defaults (touch targets, contrast, semantics).
5. Mobile-first, tablet-ready behavior.

## Theme Scope
- Implemented now: Light mode.
- Specified now for later implementation: Dark mode role mapping.

## Design Tokens (Canonical)
The canonical token APIs are implemented in:
- `AppTokens`
- `AppColorRoles`
- `AppTypography`
- `AppBreakpoints`
- `AppTheme`

Token categories:
- Spacing: 4-point based scale.
- Shape: rounded corners with consistent radius steps.
- Elevation: low/medium/high surfaces.
- Motion: fast/normal/slow durations with eased curves.
- Sizing: minimum touch target and icon sizes.

## Layout and Responsive Rules
- Compact (mobile): width < 600.
- Medium (tablet-ready): 600 <= width < 840.
- Expanded: width >= 840.

Current implementation target:
- Full compact behavior.
- Medium/expanded adaptation rules documented and scaffold-ready.

## Localization and RTL Rules
- Arabic UI must mirror directional layout where appropriate.
- Text and icon alignment must respect `Directionality`.
- Components must tolerate Turkish/Arabic text length expansion.
- Locale-sensitive typography must be resolved at theme/app level.

## Accessibility Baseline
- Minimum touch target: 48x48 logical pixels.
- Interactive controls must be discoverable via semantics.
- Critical text contrast must satisfy WCAG AA intent.
- Loading/empty/error states must be visible and announced clearly.

## MVP Screen Specification Index
See `docs/design-system/screens.md` for full specs:
1. Onboarding / Entry
2. Sign Up
3. Login
4. Home Prayer Dashboard

## Component Specification Index
See `docs/design-system/components.md` for reusable components and states.

## QA and Release Gate
See `docs/design-system/checklist.md` for mandatory design checks.

All PRs touching UI must pass design compliance CI.

## Future Additions
When adding new features:
1. Reuse existing tokens/components.
2. Extend component docs before introducing new patterns.
3. Add/adjust golden tests for visual contracts.
4. Pass design guard and checklist CI checks.
