import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/alert_history/alert_history_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('alert history page supports severity filtering', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildAlertHistoryView(MockFamilyService()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('alerts-tile-夜间离床提醒')), findsOneWidget);
    expect(find.byKey(const ValueKey('alerts-tile-午间血压波动')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('alerts-filter-P2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('alerts-tile-夜间离床提醒')), findsOneWidget);
    expect(find.byKey(const ValueKey('alerts-tile-午间血压波动')), findsNothing);
  });

  testWidgets('alert history page renders empty state when no alerts exist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildAlertHistoryView(_EmptyAlertsService()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('alerts-empty-state')), findsOneWidget);
    expect(find.text('当前没有报警记录'), findsOneWidget);
  });
}

Widget _buildAlertHistoryView(MockFamilyService service) {
  Get.testMode = true;
  Get.put<MockFamilyService>(service);
  Get.put(AlertHistoryController(Get.find<MockFamilyService>()));

  return GetMaterialApp(
    theme: AppTheme.lightTheme,
    home: const AlertHistoryView(),
  );
}

class _EmptyAlertsService extends MockFamilyService {
  @override
  List<AlertEvent> get alerts => const [];
}