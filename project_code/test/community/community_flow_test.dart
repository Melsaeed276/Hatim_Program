import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/page/admin_dashboard/admin_dashboard_page.dart';
import 'package:hatim_program/page/admin_dashboard/community_management_page.dart';
import 'package:hatim_program/page/community/communities_page.dart';
import 'package:hatim_program/page/community/community_view_page.dart';
import 'package:hatim_program/page/home_page.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:hatim_program/service/user_services.dart';

class MockCommunityServices extends Mock implements CommunityServices {}

class MockUserServices extends Mock implements UserServices {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Community Feature Integration Test', () {
    testWidgets('User can request to join a community and see its content after approval',
        (WidgetTester tester) async {
      final communityServices = MockCommunityServices();
      final userServices = MockUserServices();

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: HomePage(
          communityServices: communityServices,
          userServices: userServices,
        ),
      ));

      // Open the drawer.
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap on the "Communities" link.
      await tester.tap(find.text('Communities'));
      await tester.pumpAndSettle();

      // Verify that the "Discover Communities" list is present.
      expect(find.byType(CommunitiesPage), findsOneWidget);
      expect(find.text('Discover Communities'), findsOneWidget);

      // Tap the "Request to Join" button on the first community in the list.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Request to Join').first);
      await tester.pumpAndSettle();

      // Verify that the community does not appear in the "My Communities" list yet.
      expect(find.text('My Communities'), findsNothing);

      // Go back to the home page.
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Open the drawer.
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap on the "Admin Dashboard" link.
      await tester.tap(find.text('Admin Dashboard'));
      await tester.pumpAndSettle();

      // Tap on the community to navigate to the management page.
      await tester.tap(find.text('Test Community'));
      await tester.pumpAndSettle();

      // Verify that the community management page is displayed.
      expect(find.byType(CommunityManagementPage), findsOneWidget);

      // Tap the "Approve" button on the first pending member.
      await tester.tap(find.byIcon(Icons.check).first);
      await tester.pumpAndSettle();

      // Go back to the home page.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Open the drawer.
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap on the "Communities" link.
      await tester.tap(find.text('Communities'));
      await tester.pumpAndSettle();

      // Verify that the community now appears in the "My Communities" list.
      expect(find.text('My Communities'), findsOneWidget);

      // Tap on the community to navigate to the details page.
      await tester.tap(find.text('Test Community'));
      await tester.pumpAndSettle();

      // Verify that the community details page is displayed.
      expect(find.byType(CommunityViewPage), findsOneWidget);
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

    testWidgets('Search filters the community lists',
        (WidgetTester tester) async {
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
