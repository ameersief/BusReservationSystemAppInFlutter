import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:puzzle_2048/main.dart';

void main() {
  testWidgets('Game UI smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title '2048' is shown
    expect(find.text('2048'), findsWidgets);

    // Verify that the 'Restart' button is shown
    expect(find.text('Restart'), findsOneWidget);

    // Verify that the Score is shown
    expect(find.textContaining('Score:'), findsOneWidget);
  });
}
