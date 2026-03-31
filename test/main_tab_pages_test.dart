import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nursing_family_app/app/app.dart';

void main() {
  testWidgets('home ai summary entry navigates to ai summary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FamilyApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('home-open-ai-summary')));
    await tester.tap(find.byKey(const ValueKey('home-open-ai-summary')));
    await tester.pumpAndSettle();

    expect(find.text('AI 今日摘要引擎'), findsOneWidget);
  });

  testWidgets('health tab ai entry navigates to ai summary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FamilyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('root-nav-健康')));
    await tester.pumpAndSettle();

    final primaryFinder = find.byKey(const ValueKey('health-open-ai-summary'));
    if (primaryFinder.evaluate().isNotEmpty) {
      await tester.ensureVisible(primaryFinder);
      await tester.tap(primaryFinder);
    } else {
      final compactFinder = find.byKey(const ValueKey('health-open-ai-summary-compact'));
      await tester.ensureVisible(compactFinder);
      await tester.tap(compactFinder);
    }
    await tester.pumpAndSettle();

    expect(find.text('AI 今日摘要引擎'), findsOneWidget);
  });

  testWidgets('nursing tab feedback entry navigates to feedback page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FamilyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('root-nav-护理')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('nursing-open-feedback')));
    await tester.tap(find.byKey(const ValueKey('nursing-open-feedback')));
    await tester.pumpAndSettle();

    expect(find.text('服务体验脉冲'), findsOneWidget);
  });
}