import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/main.dart';

void main() {
  testWidgets('App starts and shows dashboard due to auto-login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    
    // Wait for the redirect to happen
    await tester.pumpAndSettle();

    // Verify that we are on the dashboard page
    // The default name in AuthNotifier for kDebugMode is "Test Farmer"
    expect(find.textContaining('Hello,'), findsOneWidget);
    expect(find.textContaining('Test Farmer'), findsOneWidget);
    
    // Check for "My Communities" section
    expect(find.text('My Communities'), findsOneWidget);
  });
}
