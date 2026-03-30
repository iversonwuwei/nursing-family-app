import 'package:flutter_test/flutter_test.dart';
import 'package:nursing_family_app/app/app.dart';

void main() {
  testWidgets('family home renders key sections', (WidgetTester tester) async {
    await tester.pumpWidget(const FamilyApp());
    await tester.pumpAndSettle();

    expect(find.text('今日状态'), findsOneWidget);
    expect(find.text('快捷入口'), findsOneWidget);
    expect(find.text('AI 家属助手'), findsOneWidget);
  });
}
