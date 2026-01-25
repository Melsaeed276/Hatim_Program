---
name: Community + Super Admin
overview: Add a new Communities domain (browse, join, membership, per-community permissions, community-owned programs) plus a Super Admin-only community lifecycle panel, integrated into the existing Flutter Web app (current Firestore-based login).
todos:
  - id: model-superadmin-flag
    content: Add `isSuperAdmin` to `UserModel` and ensure it’s loaded/saved from Firestore user docs.
    status: completed
  - id: tablet-gating-update
    content: Update `NotSupportedWebView` to allow width>600dp only for `isSuperAdmin` users; otherwise show the specified message.
    status: completed
    dependencies:
      - model-superadmin-flag
  - id: community-models-services
    content: Add Community data models + Firestore service layer (communities, members, joinRequests, inviteCodes, programs) with transactions where needed.
    status: completed
  - id: community-ui
    content: Implement Communities browse page + detail page with tab visibility by membership/permissions; implement join request and invite-code flows.
    status: completed
    dependencies:
      - community-models-services
  - id: superadmin-panel
    content: Implement Super Admin panel (create/edit/archive communities) and route wiring; gate to tablet/desktop only.
    status: completed
    dependencies:
      - model-superadmin-flag
      - tablet-gating-update
      - community-models-services
  - id: navigation-home
    content: Update routing and add a simple mobile Home hub (Programs/Communities/Profile) so communities are discoverable from the main flow.
    status: completed
    dependencies:
      - community-ui
  - id: localization
    content: Add/extend localization strings for Communities + Super Admin + the new large-screen message.
    status: completed
    dependencies:
      - community-ui
      - superadmin-panel
      - tablet-gating-update
  - id: tests
    content: Add unit/widget tests for permission evaluation, join metadata, and tablet gating behavior.
    status: completed
    dependencies:
      - community-models-services
      - tablet-gating-update
---

# Community & Super Admin Feature Plan

## Goals

- Implement **public Communities** (browse, view, join/leave) with **membership state** and **per-community permissions**.
- Implement **Super Admin** (manual `users/{id}.isSuperAdmin=true`) who can **create/edit/archive communities**.
- Keep your current choice: **no Firebase Auth gating** (so enforcement is primarily **client + service layer checks**).
- Keep your current policy: **tablet/desktop is blocked for normal users**, but **allowed for Super Admins**.

## Key repo constraints discovered

- Current “login” is Firestore user lookup by phone-number doc id; Firebase Auth is not used beyond web persistence (`project_code/lib/main.dart`).
- `NotSupportedWebView` currently blocks **all** screens >600dp (`project_code/lib/core/overlays/over_screens/not_supported_web.dart`). We will adjust it to allow large screens **only when** the loaded user has `isSuperAdmin=true`.
- Routing is currently minimal (`project_code/lib/core/routing/page_route.dart`), with `/home` going to `ProfilePage`.

## Data model (Firestore)

We will add a new top-level `communities` collection and subcollections.

```mermaid
flowchart TD
  communities[communities/{communityId}] --> members[members/{userId}]
  communities --> joinRequests[joinRequests/{requestId}]
  communities --> inviteCodes[inviteCodes/{codeId}]
  communities --> programs[programs/{programId}]

  users[users/{userId}] -->|manual flag| superAdmin[isSuperAdmin: true]
```

- **`communities/{communityId}`**
  - `name`, `description`, `status` (`active|archived`)
  - `logoUrl` (optional)
  - `createdAt`, `createdBy`
- **`communities/{communityId}/members/{userId}`**
  - `status` (`active|pending|left|removed`)
  - `joinedAt`, `joinMethod` (`request|invitation`)
  - `approvedBy` or `invitedBy`
  - `permissions` (array of strings)
  - `score` (number), `activeUser` (bool)
- **`communities/{communityId}/joinRequests/{requestId}`**
  - `userId`, `status` (`pending|approved|rejected`), `createdAt`
  - `processedBy`, `processedAt` (optional)
- **`communities/{communityId}/inviteCodes/{codeId}`**
  - `code` (also use as doc id for O(1) lookup), `createdAt`, `createdBy`
  - `expiresAt` (optional), `maxUses` (optional), `uses` (int), `active` (bool)
- **`communities/{communityId}/programs/{programId}`** (MVP)
  - `type` (`quran|zikir|future`), `title`, `createdAt`, `createdBy`, `communityId`

## App architecture additions

Create a new feature module under `project_code/lib/features/community/`:

- **models**: `community.dart`, `community_member.dart`, `join_request.dart`, `invite_code.dart`, `community_program.dart`, `community_permission.dart`
- **services**: `community_service.dart` (Firestore access + transactions)
- **controllers**: `community_controller.dart` (UI state + streams)
- **pages**:
  - `communities_page.dart` (browse + join + “enter invite code”)
  - `community_detail_page.dart` (Programs/Members/Requests/Settings tabs with visibility by role)
  - `super_admin_panel_page.dart` (create/edit/archive communities; tablet/desktop only)

## Navigation / UI integration

- Update router in [`project_code/lib/core/routing/page_route.dart`](project_code/lib/core/routing/page_route.dart) to add:
  - `/communities` (browse)
  - `/communities/:id` (detail)
  - `/super-admin` (panel)
- Keep `/home` but change its builder to a simple **Home hub** (MVP):
  - `Programs` (can reuse `ProgramsComingSoon` initially)
  - `Communities`
  - `Profile` (existing `ProfileContent`)
  - Implement as a `NavigationBar` + `IndexedStack` on mobile.

## Tablet/Desktop gating (per your policy)

- Update [`project_code/lib/core/overlays/over_screens/not_supported_web.dart`](project_code/lib/core/overlays/over_screens/not_supported_web.dart):
  - If width > 600dp:
    - If current loaded user has `isSuperAdmin == true`: allow app
    - Else: show message **"This screen is not supported for your account."** (localized)
- Super Admin panel route `/super-admin` additionally checks:
  - If width < 600dp: show “Super Admin panel requires tablet/desktop” (localized)

## Permissions implementation (per community)

- Represent permissions as string constants (e.g. `canCreateProgram`, `canManagePrograms`, `canManageMembers`, `canEditCommunity`).
- Implement a small pure function `hasPermission(member, permission)` and unit test it.
- Enforce in UI + service methods:
  - Approve join requests: requires `canManageMembers`.
  - Generate invite code: requires `canManageMembers`.
  - Edit community settings: requires `canEditCommunity`.
  - Create programs: requires `canCreateProgram`.

## Super Admin implementation

- Extend [`project_code/lib/features/auth/models/user_model.dart`](project_code/lib/features/auth/models/user_model.dart) with `isSuperAdmin` (default false) and wire through `fromJson/toJson`.
- Show entry point in Profile UI (only when `isSuperAdmin`) to open `/super-admin`.

## Testing strategy (MVP)

Add tests under `project_code/test/`:

- Unit: permission evaluation, join metadata mapping, responsive gating logic (super admin vs normal on width>600).
- Widget: community browse list renders + join dialog creates pending state (mock service/controller).

## Security note (explicit)

Because we are not using Firebase Auth, **Firestore rules cannot reliably enforce** roles/permissions. This plan delivers the feature behavior, but security hardening should be a follow-up (recommended: add background Firebase anonymous auth + rules, or full Firebase Auth login).