// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_myfirstapp/main.dart';

void main() {
  testWidgets("スタート画面が表示される", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const MyApp());

    expect(find.text("スライドパズル"), findsOneWidget);
    expect(find.text("スタート"), findsOneWidget);
  });

  testWidgets("スタートボタンをタップすると、パズル画面が表示される", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text("スタート"));
    await tester.pumpAndSettle();

    for (var i = 1; i < 9; i++) {
      expect(find.text(i.toString()), findsOneWidget);
    }
    expect(find.text("シャッフル"), findsOneWidget);
  });
}
