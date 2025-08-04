// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:flutter/material.dart';
import 'package:flutter_giphy/src/giphy_feature/giphy_item_details_view.dart';
import 'package:flutter_giphy/src/giphy_feature/giphy_item_list_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyWidget', () {
    testWidgets('should display a string of text', (WidgetTester tester) async {
      // Define a Widget
      const myWidget = MaterialApp(
        home: Scaffold(
          body: Text('Hello'),
        ),
      );

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);

      // Verify myWidget shows some text
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('Giphy App title is visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GiphyItemDetailsView(),
        ),
      );

      expect(find.text('Search favorite gif...'), findsOneWidget);
    });

    testWidgets('Giphy item list view is visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GiphyItemListView(),
        ),
      );

      expect(find.text('Flutter Mobile App.'), findsOneWidget);
    });
  });
}
