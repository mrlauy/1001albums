import 'package:albums/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Album Page Tests', () {
    testWidgets('Should render', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AboutPage(),
      ));

      expect(find.text('1001 Albums'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -300));
      await tester.pump();

      expect(find.text('powered by Brink-IT'), findsOneWidget);
    });
  });
}
