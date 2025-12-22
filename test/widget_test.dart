import 'package:RTEF/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import the main.dart file where MyApp is defined.

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Use MyApp here.

    // Verify that our initial text is 'Radio Tele Evangelique Florida'.
    expect(find.text('Radio Tele Evangelique Florida'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the initial text is no longer present.
    expect(find.text('Radio Tele Evangelique Florida'), findsNothing);
    // Verify that the incremented text is present.
    expect(find.text('1'), findsOneWidget);
  });
}
