import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/app.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/visit/visit_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('visit tab can navigate to video call and ai visit assistant', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FamilyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('root-nav-探视')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('visit-open-video-call')));
    await tester.tap(find.byKey(const ValueKey('visit-open-video-call')));
    await tester.pumpAndSettle();
    expect(find.text('远程视频链路'), findsOneWidget);

    Get.back();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('visit-open-ai-assistant')));
    await tester.tap(find.byKey(const ValueKey('visit-open-ai-assistant')));
    await tester.pumpAndSettle();
    expect(find.text('AI 探视编排'), findsOneWidget);
  });

  testWidgets('visit view renders stable empty states when history and suggestions are absent', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.put<MockFamilyService>(_EmptyVisitService());
    Get.put(VisitController(Get.find<MockFamilyService>()));

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        home: const VisitView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('visit-suggestions-empty-state')), findsOneWidget);
    expect(find.byKey(const ValueKey('visit-history-empty-state')), findsOneWidget);
  });

  testWidgets('home and profile entry actions navigate to secondary pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FamilyApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('home-quick-action-消息中心')));
    await tester.tap(find.byKey(const ValueKey('home-quick-action-消息中心')));
    await tester.pumpAndSettle();
    expect(find.text('消息驾驶舱'), findsOneWidget);

    Get.back();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('root-nav-我的')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('profile-action-报警历史')));
    await tester.tap(find.byKey(const ValueKey('profile-action-报警历史')));
    await tester.pumpAndSettle();
    expect(find.text('预警轨迹'), findsOneWidget);
  });
}

class _EmptyVisitService extends MockFamilyService {
  @override
  List<VisitAppointment> get visitHistory => const [];

  @override
  List<String> get visitSuggestions => const [];
}