# Firestore Schema Documentation

## Overview
This document describes the Firestore data model for the Hatim Program app, focusing on group management and user progress tracking.

## Collections

### `groups/{groupId}`
Main collection storing group metadata and configuration.

**Fields:**
- `group_id` (string): Unique identifier for the group
- `adminId` (string, optional): User ID of the group creator/admin
- `name` (string): Display name of the group
- `round` (int): Current round number (legacy field, kept for backward compatibility)
- `users` (array<string>): List of user IDs in this group
- `userCount` (int): Maximum number of users allowed
- `groupDateCount` (int): Number of rounds/periods in the hatim program
- `dateType` (int): 0=week, 1=day (enum index)
- `calendarType` (int): 0=hijri, 1=gregorian (enum index)
- `hatimStyle` (int): 0=allTogetherInOneHatim, 1=byRounds, 2=byChallenge (enum index)
- `status` (int): 0=waiting, 1=active, 2=finished (enum index)
- `created_date` (timestamp): When the group was created
- `start_date` (timestamp, optional): When the group became active
- `end_date` (timestamp, optional): Calculated end date
- `planned_start_date` (timestamp, optional): Admin-set start date
- `hijriStartYear` (int, optional): Hijri calendar start year
- `hijriStartMonth` (int, optional): Hijri calendar start month
- `hijriStartDay` (int, optional): Hijri calendar start day
- `startHour` (int, optional): Start time hour
- `startMinute` (int, optional): Start time minute

**Note:** This document does NOT store user completion data. That is stored in the `progress` subcollection.

---

### `groups/{groupId}/progress/{userId}` (NEW - Source of Truth)
**Purpose:** Single source of truth for each user's hatim completion progress within a group.

**Fields:**
- `completedRoundIds` (array<int>): List of round IDs this user has completed
- `updatedAt` (serverTimestamp): Last update timestamp
- `currentRound` (int, optional): Cached current round number (can be derived from completedRoundIds)

**Access Pattern:**
- **Write:** When user completes a round, use `FieldValue.arrayUnion([roundId])` to add to `completedRoundIds`
- **Read:** Stream this document to get real-time updates of user progress
- **Query:** Not typically queried; accessed by userId directly

**Example Document:**
```json
{
  "completedRoundIds": [1, 2, 3],
  "currentRound": 4,
  "updatedAt": "2025-01-04T10:30:00Z"
}
```

---

### `groups/{groupId}/hatimRounds/{roundId}` (LEGACY - Read Only)
**Purpose:** Legacy subcollection for backward compatibility and admin views. New writes should go to `progress/{userId}` instead.

**Fields:**
- `roundID` (int): The round number
- `completedUserIDs` (array<string>): List of user IDs who completed this round

**Migration Strategy:**
- Keep this collection for existing groups
- Admin views can still read from here during transition
- New completion writes go to `progress/{userId}`
- Optional: backfill `progress/{userId}` from `completedUserIDs` on first access

---

### `groups/{groupId}/roundStats/{roundId}` (OPTIONAL - Future Enhancement)
**Purpose:** Aggregated statistics for each round, updated transactionally when users complete rounds.

**Fields:**
- `roundId` (int): The round number
- `completedCount` (int): Number of users who completed this round
- `totalUsers` (int): Total users in the group (for progress calculation)
- `updatedAt` (serverTimestamp): Last update timestamp

**Access Pattern:**
- Updated using `FieldValue.increment(1)` in the same transaction as progress update
- Read by admin views to show group-wide progress without counting individual progress docs

---

## Data Flow

### User Completes Current Round
```
1. Client calls: completeRound(groupId, userId, roundId)
2. Transaction:
   a. Read groups/{groupId}/progress/{userId}
   b. Check if roundId already in completedRoundIds
   c. If not: arrayUnion roundId, update timestamp
   d. (Optional) Increment groups/{groupId}/roundStats/{roundId}.completedCount
3. Client streams progress doc → UI updates automatically
```

### Determining Current Round
```
Client-side calculation:
- Sort completedRoundIds
- Current round = (max completed round) + 1
- Or: iterate rounds 1..N, return first not in completedRoundIds
```

### Admin View: Group Progress
```
Option 1 (using progress docs):
- Query groups/{groupId}/progress for all users
- Count how many have roundId in completedRoundIds

Option 2 (using roundStats):
- Read groups/{groupId}/roundStats/{roundId}.completedCount
- Faster, but requires maintaining stats
```

---

## Migration from Old Schema

### Before (Current Schema)
- Completion stored in: `groups/{groupId}/hatimRounds/{roundId}.completedUserIDs`
- Problem: Hard to query per-user, requires loading all rounds to find user's current round

### After (New Schema)
- Completion stored in: `groups/{groupId}/progress/{userId}.completedRoundIds`
- Benefits: 
  - Single doc per user (fast reads)
  - Real-time streams per user
  - Easy to determine current round
  - Idempotent writes (arrayUnion)

### Backfill Strategy
```
For each group:
  For each user in group.users:
    If progress/{userId} doesn't exist:
      Create it by reading all hatimRounds docs
      Extract rounds where user is in completedUserIDs
      Write progress/{userId} with those roundIds
```

---

## Security Rules (Recommended)

```javascript
// Allow users to read their own progress
match /groups/{groupId}/progress/{userId} {
  allow read: if request.auth.uid == userId;
  allow write: if request.auth.uid == userId 
    && request.resource.data.completedRoundIds is list
    && request.resource.data.updatedAt == request.time;
}

// Allow group members to read group metadata
match /groups/{groupId} {
  allow read: if request.auth.uid in resource.data.users;
  allow write: if request.auth.uid == resource.data.adminId;
}

// Optional: roundStats (if implemented)
match /groups/{groupId}/roundStats/{roundId} {
  allow read: if request.auth.uid in get(/databases/$(database)/documents/groups/$(groupId)).data.users;
  allow write: if false; // Only via transactions from authenticated writes
}
```

---

## Performance Considerations

1. **Indexes:** No special indexes needed for basic operations (direct doc access by userId)
2. **Caching:** Client can cache progress docs with 5-minute TTL
3. **Offline:** Firestore offline persistence works well with this model
4. **Scalability:** O(1) reads per user, O(users) for admin group progress view

---

## Future Enhancements

1. **Cloud Functions:** Add server-side validation/aggregation for critical operations
2. **Batch Completion:** Allow users to mark multiple rounds complete at once
3. **Undo:** Store completion history to allow undo within time window
4. **Notifications:** Trigger when user completes a round or group finishes
