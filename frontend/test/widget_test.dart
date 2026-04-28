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
    expect(find.text('Hello, Gilbert!'), findsOneWidget);
    
    // Check for "My Communities" section
    expect(find.text('My Communities'), findsOneWidget);
  });
}
