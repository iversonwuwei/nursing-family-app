import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/bills/bills_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('bills page supports status filtering', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildBillsView(MockFamilyService()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('bills-tile-2026 年 3 月护理账单')), findsOneWidget);
    expect(find.byKey(const ValueKey('bills-tile-2026 年 2 月护理账单')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bills-filter-已支付')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('bills-tile-2026 年 2 月护理账单')), findsOneWidget);
    expect(find.byKey(const ValueKey('bills-tile-2026 年 3 月护理账单')), findsNothing);
  });

  testWidgets('bills page renders empty state when no bills exist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildBillsView(_EmptyBillsService()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('bills-empty-state')), findsOneWidget);
    expect(find.text('当前没有账单记录'), findsOneWidget);
  });
}

Widget _buildBillsView(MockFamilyService service) {
  Get.testMode = true;
  Get.put<MockFamilyService>(service);
  Get.put(BillsController(Get.find<MockFamilyService>()));

  return GetMaterialApp(
    theme: AppTheme.lightTheme,
    home: const BillsView(),
  );
}

class _EmptyBillsService extends MockFamilyService {
  @override
  List<BillItem> get bills => const [];
}