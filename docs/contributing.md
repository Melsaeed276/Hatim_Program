# Contributing

## Workflow
1. Start from an open GitHub issue.
2. Create a branch tied to the issue.
3. Implement only the scoped changes.
4. Run checks locally.
5. Open PR linked to the issue.

## Branch Naming
Use issue-based branch names, for example:
- `codex/issue-5-docs-baseline`
- `codex/issue-12-prayer-logic`

## Pull Request Expectations
- PR description must include:
  - Problem being solved.
  - Scope of change.
  - Test evidence.
  - Linked issue number.
- Keep PRs focused and small.
- Update docs when behavior or architecture changes.

## Local Validation
Run from `project_code/` before opening PR:
```bash
flutter pub get
flutter analyze
flutter test
```

## Definition of Done
- Acceptance criteria in the issue are met.
- Code and docs are consistent.
- Tests are added/updated where relevant.
- No unrelated changes included.
