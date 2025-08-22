// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_giphy/src/giphy_feature/gif_detail_view.dart';
import 'package:flutter_giphy/src/giphy_feature/giphy_item_view.dart';
import 'package:flutter_giphy/src/giphy_feature/mobile_app_list_view.dart';
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
          home: GiphyItemView(),
        ),
      );

      expect(find.text('Search favorite gif...'), findsOneWidget);
    });

    testWidgets('Giphy item list view is visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileAppListView(),
        ),
      );

      expect(find.text('Flutter Mobile App.'), findsOneWidget);
    });

    setUpAll(() => HttpOverrides.global = null);
    testWidgets('Giphy DetailView title and Gif\'s title is visible',
        (tester) async {
      const title = 'My Title';
      const rating = "g";
      const gifUrl = "https://picsum.photos/200/300";
      const originalHeight = 225.0;
      const originalWidth = 400.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: GifDetailView(
            title: title,
            rating: rating,
            gifUrl: gifUrl,
            width: originalWidth,
            height: originalHeight,
          ),
        ),
      );

      await tester.pump(); // Let the widget settle

      expect(find.text('GIF Detail'), findsOneWidget);
      expect(find.text('Title: My Title'), findsOneWidget);
      expect(find.text('Rating: g'), findsOneWidget);
    });
  });
}
