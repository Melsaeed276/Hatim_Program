# Components

## Usage Contract
- Reusable UI components must read values from theme/tokens.
- Component states are mandatory: enabled, disabled, loading, error, success (when relevant).
- Interactive controls must include semantics and 48x48 minimum touch area.

## App Bar
- Variant: small top app bar for MVP screens.
- Behavior: title only on simple screens, title + action on dashboard.
- Colors: `colorScheme.surface` + on-surface text.

## Buttons
### Primary Action
- Widget: Filled button.
- Use: main screen action (continue, sign in, submit).
- States: enabled, disabled, loading.

### Secondary Action
- Widget: Outlined button.
- Use: alternate action (skip, back, alternate auth path).

### Tertiary Action
- Widget: Text button.
- Use: low-emphasis actions and inline support links.

## Text Fields
- Variant: outlined fields for form consistency.
- Required states: default, focused, error, disabled.
- Validation messaging appears below field.
- Password fields must expose show/hide toggle and accessible labels.

## Cards
- Role: grouped, readable content blocks.
- Variants:
  - Standard content card.
  - Status card (prayer state).
- Elevation: low by default, medium for priority cards.

## Status Blocks
Used in prayer dashboard:
- Current prayer block.
- Next prayer block.
- Countdown block.

Rules:
- Emphasize hierarchy with typography and spacing, not strong color overload.
- Use semantic roles for highlights.

## Feedback Components
### Loading
- Circular progress + concise status text.

### Empty State
- Short title, one-line explanation, one recovery action.

### Error State
- Human-readable message + retry action.
- Preserve safe fallback content where possible.

## List Rows
- Use consistent vertical rhythm and row density.
- Keep leading/trailing content aligned by baseline.

## Chips and Badges
- Use sparingly for metadata tags and secondary context.
- Avoid replacing primary information architecture.

## Shared Widgets
Initial reusable widgets expected in scaffold:
- AppSectionCard
- AppStatusBlock
- AppEmptyState
- AppErrorState
- AppLoadingState

When adding a new shared widget:
1. Add token usage notes.
2. Add state definitions.
3. Add semantics rules.
4. Add/update golden tests.
