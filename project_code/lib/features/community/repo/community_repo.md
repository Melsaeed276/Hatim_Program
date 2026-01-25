# CommunityRepo Documentation

This document explains the role, responsibilities, and usage of `CommunityRepo`, which acts as the **single entry point** between ViewModels and the Community domain.

---

## 1. Purpose & Architecture

`CommunityRepo` sits **between ViewModels and Services**.

**Key rules of the architecture:**

- ✅ ViewModels **must call the Repo only**
- ❌ ViewModels must **never call services directly**
- ✅ Repo validates, normalizes, and prepares input
- ✅ Repo may call **one or multiple services** in a single method
- ✅ Repo is responsible for local data sources (SharedPreferences, cache) if needed
- ❌ Services never know about UI or ViewModels

This creates a clean separation:

```
ViewModel  →  Repository  →  Service  →  Firestore
```

---

## 2. Responsibilities of CommunityRepo

CommunityRepo is responsible for:

- Input validation (empty strings, invalid numbers, invalid country codes)
- Input normalization (trim strings, uppercase country codes, deduplicate lists)
- Coordinating multiple service calls when needed
- Providing a **stable API** for ViewModels
- Hiding Firestore / transaction complexity from the UI layer

The Repo **does not**:

- Perform UI logic
- Contain Firestore queries directly
- Replace security rules

---

## 3. Error Handling Strategy

CommunityRepo throws standard Dart errors that ViewModels should handle:

- `ArgumentError`
  - Invalid input (empty IDs, empty titles, negative limits, invalid country codes)

- `StateError`
  - Business rule violations (not a member, program full, program not found)

### Recommended ViewModel pattern

```dart
try {
  await repo.joinProgram(
    communityId: cid,
    programId: pid,
    userId: uid,
  );
} on ArgumentError catch (e) {
  // Show validation message
} on StateError catch (e) {
  // Show business-rule message
} catch (e) {
  // Unexpected error
}
```

---

## 4. Read APIs (Streams & Queries)

These methods are **read-only** and safe to call from ViewModels.

### Communities

- `streamCommunities({bool includeArchived})`
- `getCommunity(communityId)`

### Membership

- `streamMyMembership(communityId, userId)`
- `streamMembers(communityId)`
- `streamMyMembershipRefsFromUserIndex(userId)`

### Join Requests (Admin)

- `streamJoinRequests(communityId)`

### Programs

- `streamPrograms(communityId)`
- `getMyProgramsAcrossCommunities(userId)`

### Program Participants

- `streamProgramParticipants(communityId, programId)`
- `streamProgramParticipantCount(communityId, programId)`

---

## 5. Community Write APIs

### Create community

```dart
repo.createCommunity(
  name: 'Ramadan Hatim',
  description: 'Daily group hatim',
  createdCountry: 'TR',
  allowedCountries: ['TR', 'DE'],
  createdBy: adminId,
);
```

**Repo guarantees:**
- name & description are non-empty
- country codes are ISO-3166 alpha-2
- allowedCountries is normalized and deduplicated

---

### Update community

```dart
repo.updateCommunity(
  communityId: cid,
  name: 'Updated name',
  allowedCountries: ['TR'],
);
```

Only provided fields are updated.

---

### Archive community

```dart
repo.archiveCommunity(communityId);
```

---

## 6. Membership & Join Flow

### Create join request (User)

```dart
repo.createJoinRequest(
  communityId: cid,
  userId: uid,
);
```

> Country allow-list enforcement can be added here later without changing ViewModels.

---

### Approve / Reject join request (Admin)

```dart
repo.approveJoinRequest(
  communityId: cid,
  requestId: rid,
  adminId: adminId,
);
```

```dart
repo.rejectJoinRequest(
  communityId: cid,
  requestId: rid,
  adminId: adminId,
);
```

---

### Leave / Remove member

```dart
repo.leaveCommunity(
  communityId: cid,
  userId: uid,
);
```

```dart
repo.removeMember(
  communityId: cid,
  targetUserId: uid,
  adminId: adminId,
);
```

---

### Set member permissions (Admin)

```dart
repo.setMemberPermissions(
  communityId: cid,
  targetUserId: uid,
  permissions: [
    CommunityPermission.canCreateProgram,
    CommunityPermission.canManageMembers,
  ],
);
```

Repo trims, deduplicates, and normalizes permissions.

---

## 7. Invite Codes

### Create invite code

```dart
repo.createInviteCode(
  communityId: cid,
  adminId: adminId,
  length: 8,
  maxUses: 10,
);
```

### Redeem invite code

```dart
final communityId = await repo.redeemInviteCode(
  userId: uid,
  code: 'ABCD1234',
);
```

Returns `communityId` or `null` if invalid.

---

## 8. Programs

### Create program

```dart
repo.createProgram(
  communityId: cid,
  type: CommunityProgramType.quran,
  programTitle: 'Ramadan Hatim',
  userLimit: 30,
  createdBy: adminId,
);
```

### Update program

```dart
repo.updateProgram(
  communityId: cid,
  programId: pid,
  programTitle: 'Updated title',
  userLimit: 20,
);
```

---

## 9. Program Participation

### Join program

```dart
repo.joinProgram(
  communityId: cid,
  programId: pid,
  userId: uid,
);
```

Repo guarantees:
- user is an **active** community member
- `userLimit` is enforced
- operation is transactional and idempotent

---

### Leave program

```dart
repo.leaveProgram(
  communityId: cid,
  programId: pid,
  userId: uid,
);
```

---

## 10. Why this Repo Matters

- ViewModels stay thin and testable
- Business rules live in one place
- Firestore logic stays out of UI
- New data sources (cache, REST, local DB) can be added without changing ViewModels

If you later add SharedPreferences, caching, or offline logic, **it belongs here**.

---

## 11. Summary

- CommunityRepo is the **single source of truth** for the Community feature
- ViewModels depend only on Repo
- Repo depends on Services
- Services depend on Firestore

This structure scales cleanly as the app grows.
