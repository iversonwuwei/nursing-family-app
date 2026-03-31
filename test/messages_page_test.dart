import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/messages/messages_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('messages page supports category filtering', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildMessagesView(MockFamilyService()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('messages-tile-护理完成提醒')), findsOneWidget);
    expect(find.byKey(const ValueKey('messages-tile-探视预约通过')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('messages-filter-探视')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('messages-tile-探视预约通过')), findsOneWidget);
    expect(find.byKey(const ValueKey('messages-tile-护理完成提醒')), findsNothing);
  });

  testWidgets('messages page renders empty state when no notifications', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildMessagesView(_EmptyMessagesService()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('messages-empty-state')), findsOneWidget);
    expect(find.text('当前没有新消息'), findsOneWidget);
  });
}

Widget _buildMessagesView(MockFamilyService service) {
  Get.testMode = true;
  Get.put<MockFamilyService>(service);
  Get.put(MessagesController(Get.find<MockFamilyService>()));

  return GetMaterialApp(
    theme: AppTheme.lightTheme,
    home: const MessagesView(),
  );
}

class _EmptyMessagesService extends MockFamilyService {
  @override
  List<NotificationItem> get notifications => const [];
}