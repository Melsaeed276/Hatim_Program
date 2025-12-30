import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/models/models.dart';

void main() {
  group('Quran Chapter Assignment Algorithms (Lean Storage)', () {
    test('Round 1 assignment for 30 users (AllTogetherInOneHatim)', () {
      final group = GroupModel.withCustomInfo(
        groupID: '123456',
        name: 'Full Group',
        userCount: 30,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
      );

      for (int i = 1; i <= 30; i++) {
        group.addUserToGroup('user$i');
      }

      final round1 = group.hatimRounds.firstWhere((r) => r.roundID == 1);
      final assignedChapters =
          group.usersID
              .map(
                (id) =>
                    round1.getJuzForUser(id, group.usersID, group.hatimStyle),
              )
              .toList()
            ..sort();

      // Should have all chapters from 1 to 30
      expect(assignedChapters, List.generate(30, (i) => i + 1));

      // User 1 should have Juz 1, User 30 should have Juz 30
      expect(round1.getJuzForUser('user1', group.usersID, group.hatimStyle), 1);
      expect(
        round1.getJuzForUser('user30', group.usersID, group.hatimStyle),
        30,
      );
    });

    test('Rotation ensures everyone reads a different Juz each round', () {
      final group = GroupModel.withCustomInfo(
        groupID: '123456',
        name: 'Rotation Group',
        userCount: 30,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
      );

      for (int i = 1; i <= 30; i++) {
        group.addUserToGroup('user$i');
      }

      // Check User 1 across 30 rounds
      Set<int> user1Chapters = {};
      for (var round in group.hatimRounds) {
        user1Chapters.add(
          round.getJuzForUser('user1', group.usersID, group.hatimStyle),
        );
      }

      expect(
        user1Chapters.length,
        30,
        reason: 'User 1 should read all 30 Juz over 30 rounds',
      );
      expect(user1Chapters, containsAll(List.generate(30, (i) => i + 1)));
    });

    test('Large roundID wrap around logic (The Bug Test)', () {
      final userList = List.generate(30, (i) => 'user${i + 1}');

      final round61 = HatimRoundModel(roundID: 61);

      // User 1 (index 0) + round 61 = 61. giveChapterNumber(61) -> 1
      expect(
        round61.getJuzForUser(
          'user1',
          userList,
          HatimStyle.allTogetherInOneHatim,
        ),
        1,
        reason: 'Round 61 should wrap to Juz 1',
      );
    });

    test(
      'byRounds style: everyone reads the same Juz and it increments each round',
      () {
        final group = GroupModel.withCustomInfo(
          groupID: '789',
          name: 'Sequential Group',
          userCount: 5,
          hatimStyle: HatimStyle.byRounds,
        );

        for (int i = 1; i <= 5; i++) {
          group.addUserToGroup('user$i');
        }

        for (int r = 1; r <= 30; r++) {
          final round = group.hatimRounds.firstWhere(
            (round) => round.roundID == r,
          );
          for (var user in group.usersID) {
            expect(
              round.getJuzForUser(user, group.usersID, group.hatimStyle),
              r,
              reason: 'In round $r, every user should be reading Juz $r',
            );
          }
        }

        // Test wrap around
        final round31 = HatimRoundModel(roundID: 31);
        expect(
          round31.getJuzForUser('user1', group.usersID, HatimStyle.byRounds),
          1,
          reason: 'Round 31 should wrap to Juz 1 for byRounds',
        );
      },
    );

    test('Sequential property: no two users in same round read same Juz', () {
      final group = GroupModel.withCustomInfo(
        groupID: '123456',
        name: 'Uniqueness Group',
        userCount: 30,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
      );

      for (int i = 1; i <= 30; i++) {
        group.addUserToGroup('user$i');
      }

      for (var round in group.hatimRounds) {
        final chapters = group.usersID
            .map(
              (id) => round.getJuzForUser(id, group.usersID, group.hatimStyle),
            )
            .toSet();
        expect(
          chapters.length,
          30,
          reason: 'Every user in Round ${round.roundID} must have a unique Juz',
        );
      }
    });
  });
}
