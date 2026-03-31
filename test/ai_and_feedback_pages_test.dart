import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/ai_today_summary/ai_today_summary_page.dart';
import 'package:nursing_family_app/app/modules/ai_visit_assistant/ai_visit_assistant_page.dart';
import 'package:nursing_family_app/app/modules/feedback/feedback_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('ai today summary switches prompt and renders answer card', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.put<MockFamilyService>(MockFamilyService());
    Get.put(AiTodaySummaryController(Get.find<MockFamilyService>()));

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        home: const AiTodaySummaryView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ai-summary-answer-card')), findsOneWidget);
    expect(find.textContaining('下午有一次康复训练安排'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('ai-summary-prompt-1')));
    await tester.tap(find.byKey(const ValueKey('ai-summary-prompt-1')));
    await tester.pumpAndSettle();

    expect(find.textContaining('132/82 mmHg'), findsOneWidget);
  });

  testWidgets('ai today summary renders empty state when prompts are absent', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.put<MockFamilyService>(_EmptyAiSummaryService());
    Get.put(AiTodaySummaryController(Get.find<MockFamilyService>()));

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        home: const AiTodaySummaryView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ai-summary-empty-state')), findsOneWidget);
  });

  testWidgets('ai visit assistant renders empty state when suggestions are absent', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.put<MockFamilyService>(_EmptyAiVisitService());
    Get.put(AiVisitAssistantController(Get.find<MockFamilyService>()));

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        home: const AiVisitAssistantView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ai-visit-empty-state')), findsOneWidget);
  });

  testWidgets('feedback page updates rating and selected tags', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    final controller = Get.put(FeedbackController());

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        home: const FeedbackView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('4.0'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('feedback-rating-5')));
    await tester.pumpAndSettle();
    expect(find.text('5.0'), findsOneWidget);
    expect(controller.rating.value, 5);

    await tester.ensureVisible(find.byKey(const ValueKey('feedback-tag-沟通清晰')));
    await tester.tap(find.byKey(const ValueKey('feedback-tag-沟通清晰')));
    await tester.pumpAndSettle();
    expect(controller.selectedTags.contains('沟通清晰'), isTrue);
    expect(controller.selectedTags.length, 1);
  });
}

class _EmptyAiSummaryService extends MockFamilyService {
  @override
  List<AiPromptItem> get todayAiPrompts => const [];
}

class _EmptyAiVisitService extends MockFamilyService {
  @override
  List<String> get visitSuggestions => const [];
}