import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/page/community/communities_page.dart';
import 'package:hatim_program/page/community/community_details_page.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Community Feature Integration Test', () {
    testWidgets('User can join a community and see its content', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(home: CommunitiesPage()));

      // Verify that the "Discover Communities" list is present.
      expect(find.text('Discover Communities'), findsOneWidget);

      // Tap the "Join" button on the first community in the list.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Join').first);
      await tester.pumpAndSettle();

      // Verify that the community now appears in the "My Communities" list.
      expect(find.text('My Communities'), findsOneWidget);

      // Tap on the community to navigate to the details page.
      await tester.tap(find.text('Test Community'));
      await tester.pumpAndSettle();

      // Verify that the community details page is displayed.
      expect(find.byType(CommunityDetailsPage), findsOneWidget);
      expect(find.text('Test Community'), findsOneWidget);

      // Verify that the Hatim and Zikir lists are present.
      expect(find.text('Hatim Programs'), findsOneWidget);
      expect(find.text('Zikirs'), findsOneWidget);

      // Verify the Zikir counter logic.
      expect(find.text('Count: 0'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Count: 1'), findsOneWidget);
    });

    testWidgets('Search filters the community lists', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(home: CommunitiesPage()));

      // Verify that both "Test Community" and "Another Community" are present.
      expect(find.text('Test Community'), findsOneWidget);
      expect(find.text('Another Community'), findsOneWidget);

      // Enter "Test" into the search field.
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pumpAndSettle();

      // Verify that only "Test Community" is present.
      expect(find.text('Test Community'), findsOneWidget);
      expect(find.text('Another Community'), findsNothing);

      // Clear the search field.
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      // Verify that both communities are present again.
      expect(find.text('Test Community'), findsOneWidget);
      expect(find.text('Another Community'), findsOneWidget);
    });
  });
}
