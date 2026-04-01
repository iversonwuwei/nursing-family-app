import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/profile/profile_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('profile status rail does not overflow on medium width layout', (
    WidgetTester tester,
  ) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    addTearDown(() => binding.setSurfaceSize(null));

    await binding.setSurfaceSize(
      const Size(820, 1180),
    );

    await tester.pumpWidget(_buildProfileView());
    await tester.pumpAndSettle();

    expect(find.text('联动状态'), findsOneWidget);
    expect(find.text('消息链路'), findsOneWidget);
    expect(find.text('探视服务'), findsOneWidget);
    expect(find.text('AI 助理'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _buildProfileView() {
  Get.testMode = true;
  Get.put<MockFamilyService>(MockFamilyService());
  Get.put(ProfileController(Get.find<MockFamilyService>()));

  return GetMaterialApp(
    theme: AppTheme.lightTheme,
    home: const Scaffold(body: ProfileView()),
  );
}
